import CallKit
import Foundation
import JitsiMeetSDK
import MatrixSDK
import SwiftUI

protocol GroupCallsUseCaseProtocol {
    func placeGroupCallInRoom(roomId: String)
    func joinGroupCallInRoom(eventId: String, roomId: String)
}

final class GroupCallsUseCase {

	/// Jitsi calls map. Keys are CallKit call UUIDs, values are corresponding widgets.
	private var jitsiCalls: [UUID: JitsiWidget] = [:]
	/// Utilized sessions
	private var sessions: [MXSession] = []
    private var roomId: String
	private var viewModel: AURGroupCallsViewModel?
	private let jingleCallStackConfigurator = MXJingleCallAudioSessionConfigurator()

	private var conferenceId: String?
	private var jwtToken: String?
	private var serverUrl: URL?
	private var currentCallWidget: JitsiWidget?
    private let config: ConfigType
    private let matrixUseCase: MatrixUseCaseProtocol

	private var navigationController: UINavigationController? {
		(UIApplication.shared.connectedScenes.first as? UIWindowScene)?
			.keyWindow?.rootViewController as? UINavigationController
	}

	init(
        roomId: String,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        config: ConfigType = Configuration.shared
    ) {
        self.roomId = roomId
        self.matrixUseCase = matrixUseCase
        self.config = config
        configureRoom(roomID: roomId)
	}

    private func configureRoom(roomID: String) {
        guard let room = matrixUseCase.getRoomInfo(roomId: roomID) else { return }
        self.viewModel = AURGroupCallsViewModel(room: room)
    }
}

// MARK: - GroupCallsUseCaseProtocol

extension GroupCallsUseCase: GroupCallsUseCaseProtocol {

    func placeGroupCallInRoom(roomId: String) {
        guard let room = matrixUseCase.getRoomInfo(roomId: roomId) else { return }
        placeGroupCall(in: room)
    }

    func joinGroupCallInRoom(eventId: String, roomId: String) {
        guard
            let room = matrixUseCase.getRoomInfo(roomId: roomId),
            let event = AuraRoom(room).events()
            .renderableEvents.first(where: { eventId == $0.eventId }) else {
            return
        }
        joinGroupCall(in: event, room: room)
    }

    func joinGroupCall(in event: MXEvent, room: MXRoom) {
		guard
			let widget = JitsiWidget(event: event, session: room.mxSession),
			widget.isActive
		else { return }

		self.currentCallWidget = widget
		self.viewModel?.open(widget, withVideo: false) { conferenceId, jwtToken, serverUrl in

			DispatchQueue.main.async {
				self.conferenceId = conferenceId
				self.jwtToken = jwtToken
				self.serverUrl = serverUrl
                let controller = GroupCallsAssembly.build(delegate: self)

				self.navigationController?.pushViewController(controller, animated: true)
			}
		} failure: { result in
			debugPrint("Error joinGroupCall  \(result)")
		}
	}

	func placeGroupCall(in room: MXRoom) {

		viewModel?.createJitsiWidget(in: room, withVideo: false) { [weak self] widget in

			guard let self = self,
                self.currentCallWidget == nil ||
					self.currentCallWidget?.widgetId != widget.widgetId else { return }

			self.currentCallWidget = widget
			debugPrint("success widget: \(widget)")
			self.viewModel?.open(widget, withVideo: false) { conferenceId, jwtToken, serverUrl in

				DispatchQueue.main.async {
					self.conferenceId = conferenceId
					self.jwtToken = jwtToken
					self.serverUrl = serverUrl
                    let controller = GroupCallsAssembly.build(delegate: self)

					self.navigationController?.pushViewController(controller, animated: true)
				}
			} failure: { error in
				debugPrint("Error in placeGroupCall \(error)")
			}
		} failure: {
			debugPrint("failure")
		}
	}

    private func startJitsiCall(withWidget widget: JitsiWidget) {

		guard
            let room: MXRoom = matrixUseCase.getRoomInfo(roomId: roomId),
			jitsiCalls.first(where: { $0.value.widgetId == widget.widgetId })?.key == nil,
			let session = room.mxSession,
			let room = session.room(withRoomId: widget.roomId)
		else { return }

		let newUUID = UUID()
		let handle = CXHandle(type: .generic, value: widget.roomId)
		let startCallAction = CXStartCallAction(call: newUUID, handle: handle)
		let setMutedAction = CXSetMutedCallAction(call: newUUID, muted: false)
		let transaction = CXTransaction(actions: [startCallAction, setMutedAction])

		JMCallKitProxy.request(transaction) { error in

			if error == nil {
				JMCallKitProxy.reportCallUpdate(
					with: newUUID,
					handle: widget.roomId,
					displayName: room.summary.displayName,
					hasVideo: false
				)
				JMCallKitProxy.reportOutgoingCall(with: newUUID, connectedAt: nil)
				self.jitsiCalls[newUUID] = widget
			}
		}
	}

	func conferenceOptions(
		with conferenceId: String,
		jwtToken: String,
		serverUrl: URL
	) -> JitsiMeetConferenceOptions {
		let options = JitsiMeetConferenceOptions.fromBuilder { [weak self] builder in

			builder.serverURL = serverUrl
			builder.room = conferenceId
			builder.setVideoMuted(true)
            if let room: MXRoom = self?.matrixUseCase.getRoomInfo(roomId: self?.roomId ?? "") {
                builder.setSubject(room.summary.displayName ?? room.roomId ?? "")
                builder.userInfo = .init(
                    displayName: room.mxSession.myUser.displayname ?? room.mxSession.myUser.userId ?? "",
                    andEmail: "",
                    andAvatar: nil
                )
            } else {
                builder.setSubject("Group Call")
                builder.userInfo = .init(
                    displayName: self?.roomId ?? "",
                    andEmail: "",
                    andAvatar: nil
                )
            }
			builder.token = jwtToken
			builder.setFeatureFlag("chat.enabled", withValue: false)
		}
		return options
	}
}

// MARK: - GroupCallsViewControllerDelegate

extension GroupCallsUseCase: GroupCallsViewControllerDelegate {

	func conferenceDidTerminated(controller: UIViewController) {
		(controller.view as? JitsiMeetView)?.hangUp()
        if let vc = controller.navigationController?.viewControllers[safe: 1] {
            controller.navigationController?.popToViewController(vc,
                                                                 animated: true)
        } else {
            controller.navigationController?.popViewController(animated: true)
            jingleCallStackConfigurator.configureAudioSessionAfterCallEnds()
        }
	}

	func viewDidLoad(controller: UIViewController) {

		guard let conferenceId = self.conferenceId,
			  let jwtToken = self.jwtToken
		else { return }

        let serverUrl = config.jitsiMeetURL
		jingleCallStackConfigurator.configureAudioSession(forVideoCall: true)

		let options = conferenceOptions(
			with: conferenceId,
			jwtToken: jwtToken,
			serverUrl: serverUrl
		)
		(controller.view as? JitsiMeetView)?.join(options)
		(controller.view as? JitsiMeetView)?.setAudioMuted(false)

		jingleCallStackConfigurator.audioSessionDidActivate(AVAudioSession.sharedInstance())
	}
}

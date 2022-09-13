import CallKit
import Foundation
import MatrixSDK
import SwiftUI

protocol GroupCallsUseCaseProtocol {
	func placeGroupCall(in room: MXRoom)
	func joinGroupCall(in event: MXEvent)
}

final class GroupCallsUseCase {

	/// Jitsi calls map. Keys are CallKit call UUIDs, values are corresponding widgets.
	private var jitsiCalls: [UUID: JitsiWidget] = [:]
	/// Utilized sessions
	private var sessions: [MXSession] = []
	private let room: MXRoom
	private let viewModel: AURGroupCallsViewModel

	private var conferenceId: String?
	private var jwtToken: String?
	private var serverUrl: URL?
	private var currentCallWidget: JitsiWidget?

	private var navigationController: UINavigationController? {
		(UIApplication.shared.connectedScenes.first as? UIWindowScene)?
			.keyWindow?.rootViewController as? UINavigationController
	}

	init(room: MXRoom) {
		self.room = room
		self.viewModel = AURGroupCallsViewModel(room: room)
	}
}

// MARK: - GroupCallsUseCaseProtocol

extension GroupCallsUseCase: GroupCallsUseCaseProtocol {

	func joinGroupCall(in event: MXEvent) {

		guard
			let widget = JitsiWidget(event: event, session: room.mxSession),
			widget.isActive
		else { return }

		self.currentCallWidget = widget
		self.viewModel.open(widget, withVideo: false) { conferenceId, jwtToken, serverUrl in

			DispatchQueue.main.async {
				self.conferenceId = conferenceId
				self.jwtToken = jwtToken
				self.serverUrl = serverUrl

				let controller = GroupCallsViewController()
				controller.delegate = self

				self.navigationController?.pushViewController(controller, animated: true)
			}
		} failure: { _ in
			debugPrint("Error")
		}
	}

	func placeGroupCall(in room: MXRoom) {
		viewModel.createJitsiWidget(in: room, withVideo: false) { widget in

			guard self.currentCallWidget == nil ||
					self.currentCallWidget?.widgetId != widget.widgetId else { return }

			self.currentCallWidget = widget
			debugPrint("success widget: \(widget)")
			self.viewModel.open(widget, withVideo: false) { conferenceId, jwtToken, serverUrl in

				DispatchQueue.main.async {
					self.conferenceId = conferenceId
					self.jwtToken = jwtToken
					self.serverUrl = serverUrl

					let controller = GroupCallsViewController()
					controller.delegate = self

					self.navigationController?.pushViewController(controller, animated: true)
				}
			} failure: { error in
				debugPrint("Error \(error)")
			}
		} failure: {
			debugPrint("failure")
		}
	}

	private func startJitsiCall(withWidget widget: JitsiWidget) {

		guard
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
					displayName: room.summary.displayname,
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
			builder.setSubject(self?.room.summary.displayname ?? self?.room.roomId ?? "")
			builder.userInfo = .init(
				displayName: self?.room.mxSession.myUser.displayname ?? self?.room.mxSession.myUser.userId ?? "",
				andEmail: "",
				andAvatar: nil
			)
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
		controller.navigationController?.popViewController(animated: true)
	}

	func viewDidLoad(controller: UIViewController) {

		guard let conferenceId = self.conferenceId,
			  let jwtToken = self.jwtToken,
			  let serverUrl = URL(string: "https://meet.auratest.website")
		else { return }

		let options = conferenceOptions(
			with: conferenceId,
			jwtToken: jwtToken,
			serverUrl: serverUrl
		)
		(controller.view as? JitsiMeetView)?.join(options)
		(controller.view as? JitsiMeetView)?.setAudioMuted(false)
	}
}

import JitsiMeetSDK
import UIKit

protocol GroupCallsViewControllerDelegate: AnyObject {
	func viewDidLoad(controller: UIViewController)
	func conferenceDidTerminated(controller: UIViewController)
}

final class GroupCallsViewController: UIViewController {

	weak var delegate: GroupCallsViewControllerDelegate?

	override func loadView() {
		let jitsiMeetView = JitsiMeetView()
		jitsiMeetView.delegate = self
		self.view = jitsiMeetView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		delegate?.viewDidLoad(controller: self)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black  // gives you light content status bar
	}

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.barStyle = .default // gives you dark Content status bar
    }
}

// MARK: - JistiMeetViewDelegate

extension GroupCallsViewController: JitsiMeetViewDelegate {

	func conferenceWillJoin(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL conferenceWillJoin: \(data)")
	}

	func conferenceJoined(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL conferenceJoined: \(data)")
	}

	func conferenceTerminated(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL conferenceTerminated: \(data)")
		delegate?.conferenceDidTerminated(controller: self)
	}

	func enterPicture(inPicture data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL enterPictureinPicture: \(data)")
	}

	func participantJoined(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL participantJoined: \(data)")
	}

	func participantLeft(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL participantLeft: \(data)")
	}

	func audioMutedChanged(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL audioMutedChanged: \(data)")
	}

	func endpointTextMessageReceived(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL endpointTextMessageReceived: \(data)")
	}

	func screenShareToggled(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL screenShareToggled: \(data)")
	}

	func chatMessageReceived(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL chatMessageReceived: \(data)")
	}

	func chatToggled(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL chatToggled: \(data)")
	}

	func videoMutedChanged(_ data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL videoMutedChanged: \(data)")
	}

	func ready(toClose data: [AnyHashable: Any]) {
		debugPrint("GROUP_CALL readyToClose: \(data)")
        delegate?.conferenceDidTerminated(controller: self)
	}
}

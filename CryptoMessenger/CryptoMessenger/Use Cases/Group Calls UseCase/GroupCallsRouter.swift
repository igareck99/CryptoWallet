import Foundation

final class GroupCallsRouter {

	private var navigationController: UINavigationController? {
		(UIApplication.shared.connectedScenes.first as? UIWindowScene)?
			.keyWindow?.rootViewController as? UINavigationController
	}
}

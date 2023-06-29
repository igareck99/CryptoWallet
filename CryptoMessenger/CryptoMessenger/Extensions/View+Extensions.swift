import SwiftUI

// MARK: - View ()

extension View {

    // MARK: - Internal Properties

    var uiView: UIView { UIHostingController(rootView: self).view }

    // MARK: - Internal Methods

    func hideTabBar() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let navigation = scene.windows.first?.rootViewController as? UINavigationController
            let tabBarController = navigation?.viewControllers.first as? UITabBarController
            tabBarController?.tabBar.isHidden = true
        }
    }

    func showTabBar() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let navigation = scene.windows.first?.rootViewController as? UINavigationController
            let tabBarController = navigation?.viewControllers.first as? UITabBarController
            tabBarController?.tabBar.isHidden = false
        }
    }
}

extension View {
	func placeholder(
		_ text: String,
		when shouldShow: Bool,
		alignment: Alignment = .leading
	) -> some View {
		placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(.gray) }
	}

	func placeholder<Content: View>(
		when shouldShow: Bool,
		alignment: Alignment = .leading,
		@ViewBuilder placeholder: () -> Content
	) -> some View {
		ZStack(alignment: alignment) {
			placeholder().opacity(shouldShow ? 1 : 0)
			self
		}
	}

	func segmentedControlItemTag<
		SelectionValue: Hashable,
		Background: View
	>(
		tag: SelectionValue,
		onSegmentSelect: @escaping (SelectionValue) -> Void,
		@ViewBuilder backgroundView: @escaping () -> Background
	) -> some View {
		return SegmentedControllItemContainer(
			tag: tag,
			content: self,
			onSegmentSelect: onSegmentSelect,
			backgroundView: backgroundView
		)
	}
}

extension View {
	func anyView() -> AnyView {
		AnyView(self)
	}
}

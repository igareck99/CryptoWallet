import SwiftUI

// MARK: - BaseHostingController

final class BaseHostingController<ContentView>: UIHostingController<ContentView> where ContentView: View {

    init(rootView: ContentView, isTranslucent: Bool = false) {
        super.init(rootView: rootView)
    }

    @available(*, unavailable)
    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let navigation = scene.windows.first?.rootViewController as? UINavigationController
//            navigation?.navigationBar.isHidden = false
//        }
    }
}

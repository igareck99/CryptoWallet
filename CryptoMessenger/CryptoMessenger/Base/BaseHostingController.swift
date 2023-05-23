import SwiftUI

// MARK: - BaseHostingController

final class BaseHostingController<ContentView>: UIHostingController<ContentView> where ContentView: View {

    // MARK: - Internal Properties

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Private Properties

    private let isTranslucent: Bool

    // MARK: - Lifecycle

    init(rootView: ContentView, isTranslucent: Bool = false) {
        self.isTranslucent = isTranslucent
        super.init(rootView: rootView)
    }

    @available(*, unavailable)
    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isTranslucent {
//            setupDefaultNavigationBar()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isTranslucent {
//            setupTranslucentNavigationBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

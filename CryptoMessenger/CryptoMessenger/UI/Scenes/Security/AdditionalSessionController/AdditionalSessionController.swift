import UIKit

// MARK: - AdditionalSessionController

final class AdditionalSessionController: BaseViewController {

    // MARK: - Internal Properties

    var didPopScreen: VoidBlock?

    // MARK: - Private Properties

    private lazy var customView = AdditionalSessionView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomView()
        subscribeOnCustomViewActions()
        addTapGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customView.roundCorners([.topLeft, .topRight], radius: 16)
    }

    // MARK: - Actions

    @objc private func didClose() {
        didPopScreen?()
    }

    // MARK: - Private Methods

    private func addCustomView() {
        view.background(.clear)
        customView.snap(parent: view) {
            $0.leading.bottom.trailing.equalTo($1)
            $0.height.equalTo(436)
        }
    }

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClose))
        view.addGestureRecognizer(tap)
    }

    private func subscribeOnCustomViewActions() {
        customView.didCloseTap = { [unowned self] in
            didClose()
        }
    }
}

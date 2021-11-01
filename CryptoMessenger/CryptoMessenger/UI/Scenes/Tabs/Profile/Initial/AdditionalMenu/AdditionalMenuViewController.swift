import UIKit

// MARK: - AdditionalMenuViewController

final class AdditionalMenuViewController: BaseViewController {

    // MARK: - Internal Properties

    var didProfileDetailTap: VoidBlock?
    var didAboutAppTap: VoidBlock?
    var didDeleteTap: VoidBlock?
    var didCancelTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var customView = AdditionalMenuView()

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
        dismiss(animated: true)
    }

    // MARK: - Private Methods

    private func addCustomView() {
        view.background(.clear)
        customView.snap(parent: view) {
            $0.leading.bottom.trailing.equalTo($1)
            $0.height.equalTo(700)
        }
    }

    private func subscribeOnCustomViewActions() {
        customView.didProfileDetailTap = didProfileDetailTap
        customView.didAboutAppTap = didAboutAppTap
    }

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClose))
        view.addGestureRecognizer(tap)
    }
}

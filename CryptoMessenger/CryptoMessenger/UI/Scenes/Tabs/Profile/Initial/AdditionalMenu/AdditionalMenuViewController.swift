import UIKit

// MARK: - AdditionalMenuViewController

final class AdditionalMenuViewController: BaseViewController {

    // MARK: - Internal Properties

    var didProfileDetailTap: VoidBlock?
    var didPersonalizationTap: VoidBlock?
    var didTypographyTap: VoidBlock?
    var didCancelTap: VoidBlock?
    var didAboutAppTap: VoidBlock?
    var didSecurityTap: VoidBlock?

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
        customView.didPersonalizationTap = didPersonalizationTap
        customView.didAboutAppTap = didAboutAppTap
        customView.didSecurityTap = didSecurityTap
    }

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClose))
        view.addGestureRecognizer(tap)
    }
}

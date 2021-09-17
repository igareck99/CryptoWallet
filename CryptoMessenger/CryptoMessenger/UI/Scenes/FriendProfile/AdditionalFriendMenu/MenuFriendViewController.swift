import UIKit

// MARK: - MenuFriendViewController

final class MenuFriendViewController: BaseViewController {

    // MARK: - Private Properties

    private lazy var customView = MenuFriendView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomView()
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
            $0.height.equalTo(482)
        }
    }
}

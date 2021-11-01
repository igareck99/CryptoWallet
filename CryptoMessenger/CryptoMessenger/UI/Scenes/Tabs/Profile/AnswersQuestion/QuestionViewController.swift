import UIKit

// MARK: - QuestionViewController

final class QuestionViewController: BaseViewController {

    // MARK: - Private Properties

    private lazy var customView = QuestionView()

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleBarButtonItem()
        addLeftBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Actions

    @objc private func backButtonTap() {
        let controller = ProfileViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    // MARK: - Private Methods

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.answersQuestionTitle()
    }

    private func addLeftBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.callList.back(),
            style: .done,
            target: self,
            action: #selector(backButtonTap)
        )
        navigationItem.leftBarButtonItem = settings
    }

}

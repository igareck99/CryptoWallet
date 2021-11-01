import SwiftUI
import UIKit

// MARK: - ChatViewController

final class ChatViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: ChatPresentation!

    // MARK: - Private Properties

    private lazy var customView = ChatView(frame: UIScreen.main.bounds)
    private lazy var searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        subscribeOnCustomViewActions()
        addLeftBarButtonItems()
        addRightBarButtonItems()
    }

    // MARK: - Private Methods

    private func setup() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.background(.white())
        searchController.searchBar.searchTextField.background(.paleBlue())
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.setValue(R.string.localizable.countryCodePickerCancel(), forKey: "cancelButtonText")
        searchController.searchBar.placeholder = R.string.localizable.countryCodePickerSearch()
        searchController.searchBar.sizeToFit()
        let appearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        appearance.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.2431372549, green: 0.6039215686, blue: 0.8862745098, alpha: 1)], for: .normal)
        searchController.searchBar.setSearchFieldBackgroundImage(
            .image(
                color: .clear,
                size: searchController.searchBar.intrinsicContentSize
            ),
            for: .normal
        )
        searchController.searchBar.searchTextField.clipCorners(radius: 8)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    @objc private func settingsTap() {
        showChatCreateScene()
    }

    private func addLeftBarButtonItems() {
        let logo = UIBarButtonItem(
            image: R.image.chat.logo()?.withTintColor(.blue(), renderingMode: .alwaysOriginal),
            style: .done,
            target: self,
            action: nil
        )

        let balance = UIBarButtonItem(
            title: "0.50 AUR",
            style: .plain,
            target: nil,
            action: nil
        )

        navigationItem.leftBarButtonItems = [logo, balance]
    }

    private func addRightBarButtonItems() {
        let settings = UIBarButtonItem(
            image: R.image.chat.settings(),
            style: .done,
            target: self,
            action: #selector(settingsTap)
        )

        let write = UIBarButtonItem(
            image: R.image.chat.writeMessage(),
            style: .done,
            target: self,
            action: nil
        )

        navigationItem.rightBarButtonItems = [settings, write]
    }

    private func subscribeOnCustomViewActions() {
        customView.didTapNextScene = { [unowned self] message in
            self.showChatRoomScene(userMessage: message)
        }
    }

    private func showChatRoomScene(userMessage: Message) {
        let chatRoomView = ChatRoomConfigurator.configuredView(userMessage: userMessage, delegate: nil)
        let viewController = BaseHostingController(rootView: chatRoomView)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showChatCreateScene() {
        var rootView = ChatCreateView()
        rootView.onCreateGroup = { [unowned self] in
            self.showSelectContactScene()
        }
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        viewController.modalPresentationStyle = .pageSheet
        viewController.setupDefaultNavigationBar()
        present(viewController, animated: true)
    }

    private func showSelectContactScene() {
        let rootView = SelectContactView()
        let viewController = BaseHostingController(rootView: rootView)
        viewController.hidesBottomBarWhenPushed = true
        viewController.setupDefaultNavigationBar()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ChatViewController (UISearchResultsUpdating)

extension ChatViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.searchTextField.text ?? ""
        customView.updateSearchResults(text)
    }
}

// MARK: - ChatViewController (ChatViewInterface)

extension ChatViewController: ChatViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}

// MARK: - UIImage ()

private extension UIImage {

    // MARK: - Static Methods

    static func image(color: Palette, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            color.uiColor.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

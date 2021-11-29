import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: ProfilePresentation!

    // MARK: - Private Properties

    private lazy var customView = ProfileView(frame: UIScreen.main.bounds)
    private lazy var imagePicker = ImagePicker(fromController: self)
    private lazy var additionalMenuController = AdditionalMenuViewController()

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delay(0.5) { self.setupImagePicker() }
        subscribeOnCustomViewActions()
        addLeftBarButtonItem()
        addRightBarButtonItem()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Private Methods

    private func setupImagePicker() {
        imagePicker.delegate = self
    }

    private func subscribeOnCustomViewActions() {
        customView.didTapAddPhoto = { [unowned self] in
            imagePicker.open()
        }
        customView.didTapShowPhoto = { [unowned self] in
            let images = customView.photos.compactMap { $0 }
            let viewController = PhotoEditorConfigurator.configuredViewController(images: images, delegate: nil)
            present(viewController, animated: true)
        }
        customView.didTapBuyCell = { [unowned self] in
            let vc = PaywallViewController()
            present(vc, animated: true)
        }

        additionalMenuController.didProfileDetailTap = { [unowned self] in
            additionalMenuController.dismiss(animated: true)
            let vc = ProfileDetailConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        additionalMenuController.didPersonalizationTap = { [unowned self] in
            additionalMenuController.dismiss(animated: true)
            let vc = PersonalizationConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        additionalMenuController.didSecurityTap = { [unowned self] in
            additionalMenuController.dismiss(animated: true)
            let vc = SecurityConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        additionalMenuController.didAboutAppTap = { [unowned self] in
            additionalMenuController.dismiss(animated: true)
            let vc = AboutAppConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func addLeftBarButtonItem() {
        let userMatrixId = UserCredentialsStorageService().userMatrixId
        let title = UIBarButtonItem(
            title: userMatrixId,
            style: .plain,
            target: self,
            action: #selector(leftButtonTap)
        )
        navigationItem.leftBarButtonItem = title
    }

    private func addRightBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.profile.settings(),
            style: .done,
            target: self,
            action: #selector(rightButtonTap)
        )
        navigationItem.rightBarButtonItem = settings
    }

    // MARK: - Actions

    @objc private func leftButtonTap() {
        UIPasteboard.general.string = UserCredentialsStorageService().userMatrixId
        let alert = UIAlertController(title: nil, message: "Скопировано!", preferredStyle: .alert)
        present(alert, animated: true)
        delay(0.7) { alert.dismiss(animated: true) }
    }

    @objc private func rightButtonTap() {
        additionalMenuController.didDeleteTap = { [unowned self] in
            additionalMenuController.dismiss(animated: true)
        }
        additionalMenuController.didProfileDetailTap = { [unowned self] in
            additionalMenuController.dismiss(animated: true)
            let vc = ProfileDetailConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        present(additionalMenuController, animated: true)
    }
}

// MARK: - ProfileViewController (ImagePickerDelegate)

extension ProfileViewController: ImagePickerDelegate {
    func didFinish(with result: ImagePicker.PickerResult) {
        switch result {
        case let .success(image):
            customView.addImage(image)
        default:
            break
        }
    }
}

// MARK: - ProfileViewInterface

extension ProfileViewController: ProfileViewInterface {
    func setPhotos(_ photos: [UIImage?]) {
        customView.setPhotos(photos)
    }

    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}

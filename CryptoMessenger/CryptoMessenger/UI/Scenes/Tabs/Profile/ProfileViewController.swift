import UIKit

// MARK: - ProfileViewController

final class ProfileViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: ProfilePresentation!

    // MARK: - Private Properties

    private lazy var customView = ProfileView(frame: UIScreen.main.bounds)
    private lazy var imagePicker = ImagePicker(fromController: self)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        subscribeOnCustomViewActions()
        addLeftBarButtonItem()
        addRightBarButtonItem()
        presenter?.viewDidLoad()
    }

    // MARK: - Private Methods

    private func setupImagePicker() {
        imagePicker.delegate = self
    }

    private func subscribeOnCustomViewActions() {
        customView.didTapAddPhoto = { [unowned self] in
            self.imagePicker.open()
        }
        customView.didTapShowPhoto = { [unowned self] in
            let images = self.customView.photos.compactMap { $0 }
            let viewController = PhotoEditorConfigurator.configuredViewController(images: images, delegate: nil)
            self.present(viewController, animated: true)
        }
        customView.didTapBuyCell = { [unowned self] in
            let vc = BuyCellsMenuViewController()
            self.present(vc, animated: true)
        }
    }

    private func addLeftBarButtonItem() {
        let title = UIBarButtonItem(title: "@ikea_rus", style: .plain, target: nil, action: nil)
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

    @objc private func rightButtonTap() {
        let controller = AdditionalMenuViewController()
        present(controller, animated: true)
        controller.didDeleteTap = { [unowned self] in
            controller.dismiss(animated: true)
        }
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

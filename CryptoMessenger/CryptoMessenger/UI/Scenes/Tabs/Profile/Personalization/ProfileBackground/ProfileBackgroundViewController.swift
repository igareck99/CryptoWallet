import UIKit

// MARK: - ProfileBackgroundViewController

final class ProfileBackgroundViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: ProfileBackgroundPresentation!

    // MARK: - Private Properties

    private lazy var customView = ProfileBackgroundView(frame: UIScreen.main.bounds)
    private lazy var imagePicker = ImagePicker(fromController: self)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        subscribeOnCustomViewActions()
        addTitleBarButtonItem()
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
        customView.didTapSelectPhoto = { [unowned self] in
            let vc = ProfileBackgroundPreviewConfigurator.configuredViewController(delegate: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func addTitleBarButtonItem() {
        title = R.string.localizable.profileBackgroundTitle()
    }

    private func addRightBarButtonItem() {
        let button = UIButton()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        paragraphStyle.alignment = .center
        button.titleAttributes(
            text: R.string.localizable.profileDetailRightButton(),
            [
                .paragraph(paragraphStyle),
                .font(.bold(15)),
                .color(.blue())
            ]
        )
        let item = UIBarButtonItem(title: R.string.localizable.profileDetailRightButton(),
                                   style: .done,
                                   target: self,
                                   action: nil)
        item.titleAttributes([.paragraph(paragraphStyle),
                              .font(.semibold(15)),
                              .color(.blue())], for: .normal    )
        navigationItem.rightBarButtonItem = item
    }

}

// MARK: - ProfileBackgroundViewController (ImagePickerDelegate)

extension ProfileBackgroundViewController: ImagePickerDelegate {
    func didFinish(with result: ImagePicker.PickerResult) {
        switch result {
        case let .success(image):
            customView.addImage(image)
        default:
            break
        }
    }
}

// MARK: - ProfileBackgroundViewInterface

extension ProfileBackgroundViewController: ProfileBackgroundViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }

    func setPhotos(_ photos: [UIImage?]) {
        customView.setPhotos(photos)
    }
}

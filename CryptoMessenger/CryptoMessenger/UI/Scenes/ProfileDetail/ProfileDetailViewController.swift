import UIKit

// MARK: ProfileDetailViewController

final class ProfileDetailViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: ProfileDetailPresentation!

    // MARK: - Private Properties

    private lazy var customView = ProfileDetailView(frame: UIScreen.main.bounds)
    private lazy var imagePicker = ImagePicker(fromController: self)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleBarButtonItem()
        addLeftBarButtonItem()
        addRightBarButtonItem()
        subscribeOnCustomViewActions()
        setupImagePicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }

    // MARK: - Private Methods

    private func setupImagePicker() {
        imagePicker.delegate = self
    }

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.profileDetailTitle()
    }

    private func addLeftBarButtonItem() {
        let settings = UIBarButtonItem(
            image: R.image.callList.back(),
            style: .done,
            target: self,
            action: #selector(backAction)
        )
        navigationItem.leftBarButtonItem = settings
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
                .font(.semibold(15)),
                .color(.blue())
            ]
        )
        let item = UIBarButtonItem(title: R.string.localizable.profileDetailRightButton(),
                                   style: .done,
                                   target: self,
                                   action: #selector(saveAction))
        item.titleAttributes([.paragraph(paragraphStyle),
                              .font(.semibold(15)),
                              .color(.blue())], for: .normal    )
        navigationItem.rightBarButtonItem = item
    }

    private func subscribeOnCustomViewActions() {
        customView.didLogoutTap = { [unowned self] in
            let alert = UIAlertController(title: R.string.localizable.profileDetailLogoutAlertTitle(),
                                          message: R.string.localizable.profileDetailLogoutAlertMessage(),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.profileDetailLogoutAlertCancel(),
                                          style: UIAlertAction.Style.default,
                                          handler: { _ in
                                            alert.dismiss(animated: true, completion: nil)
                                          }))
            alert.addAction(UIAlertAction(title: R.string.localizable.profileDetailLogoutAlertApprove(),
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            print("uSER logout Succesfully")
                                            alert.dismiss(animated: true, completion: nil)
                                          }))
            self.present(alert, animated: true, completion: nil)
        }
        customView.didDeleteTap = { [unowned self] in
            let alert = UIAlertController(title: R.string.localizable.profileDetailDeleteAlertTitle(),
                                          message: R.string.localizable.profileDetailDeleteAlertMessage(),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.profileDetailDeleteAlertCancel(),
                                          style: UIAlertAction.Style.default,
                                          handler: { _ in
                                            alert.dismiss(animated: true, completion: nil)
                                          }))
            alert.addAction(UIAlertAction(title: R.string.localizable.profileDetailDeleteAlertApprove(),
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            print("Account Delete Succefully")
                                            alert.dismiss(animated: true, completion: nil)
                                          }))
            self.present(alert, animated: true, completion: nil)
        }
        customView.didTapAddPhoto = { [unowned self] in
            self.imagePicker.open()
        }
    }
    @objc private func backAction() {
        self.presenter.handleButtonTap()
    }

    @objc private func saveAction() {
        customView.saveData()
        self.presenter.handleButtonTap()
    }
}

// MARK: - ProfileDetailViewController (ImagePickerDelegate)

extension ProfileDetailViewController: ImagePickerDelegate {
    func didFinish(with result: ImagePicker.PickerResult) {
        switch result {
        case let .success(image):
            customView.addImage(image)
        default:
            break
        }
    }
}

// MARK: - ProfileDetailViewInterface

extension ProfileDetailViewController: ProfileDetailViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}

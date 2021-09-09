import UIKit

// MARK: - PhotoEditorViewController 

final class PhotoEditorViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: PhotoEditorPresentation!
    var dataSource: PhotosDataSource?
    var contentView: PhotoEditorView {
        return (view as! PhotoEditorView)
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = PhotoEditorView(frame: UIScreen.main.bounds, sizeForIndex: {
            if let images = self.dataSource?.images {
                return images.count > $0 ? images[$0].size : CGSize(width: 1, height: 1)
            }
            return CGSize(width: 1, height: 1)
        })
        dataSource = PhotosDataSource(preview: contentView.previewCollection,
                                      thumbnails: contentView.thumbnailCollection)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.background(.darkBlack())
        addTitleBarButtonItem()
        addLeftBarButtonItem()
        addRightBarButtonItem()
        subscribeOnCustomViewActions()
        contentView.addGestureRecognizer(createSwipeGestureRecognizer(for: .up))
        contentView.addGestureRecognizer(createSwipeGestureRecognizer(for: .down))

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBlackNavigationBar()
        showNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.synchronizer.layoutState = .ready
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentView.synchronizer.layoutState = .configuring
    }

    // MARK: - Private Methods

    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction)
                                                -> UISwipeGestureRecognizer {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = direction
        return swipeGestureRecognizer
    }

    private func addTitleBarButtonItem() {
        navigationItem.title = R.string.localizable.photoEditorTitle()
    }

    private func addLeftBarButtonItem() {
        let back = UIBarButtonItem(
            image: R.image.photoEditor.backButton(),
            style: .done,
            target: self,
            action: #selector(backButtonTap)
        )
        navigationItem.leftBarButtonItem = back
    }

    private func addRightBarButtonItem() {
        let dotes = UIBarButtonItem(
            image: R.image.photoEditor.dotes(),
            style: .done,
            target: self,
            action: #selector(dotesButtonTap)
        )
        navigationItem.rightBarButtonItem = dotes
    }

    @objc private func backButtonTap() {
    }

    @objc private func dotesButtonTap() {
    }

    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            print("Тут переходим на экран")
        case .down:
            print("Тут переходим на экран тоже")
        default:
            break
        }
    }

    private func subscribeOnCustomViewActions() {
        contentView.didTapShare = { [unowned self] in
            guard let state = dataSource?.images.isEmpty else { return }
            guard state == false else { return }
            if dataSource?.images.isEmpty == nil { return }
            guard let data = dataSource?.images[contentView.synchronizer.activeIndex] else { return }
            let controller = UIActivityViewController(activityItems: [data],
                                                      applicationActivities: nil)
            present(controller, animated: true, completion: nil)
        }
        contentView.didTapBrush = { [unowned self] in
            let alert = UIAlertController(title: R.string.localizable.photoEditorAlertTitle(),
                                          message: R.string.localizable.photoEditorAlertMessage(),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.photoEditorAlertCancel(),
                                          style: UIAlertAction.Style.default, handler: { _ in }))
            alert.addAction(UIAlertAction(title: R.string.localizable.photoEditorAlertDelete(),
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            dataSource?.images.remove(at: contentView.synchronizer.activeIndex)
                                            contentView.synchronizer.reload()
                                          }))
            guard let state = dataSource?.images.isEmpty else { return }
            guard state == false else { return }
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - PhotoEditorViewInterface

extension PhotoEditorViewController: PhotoEditorViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}

import UIKit

final class AdditionalViewController: BaseViewController {

    // MARK: - Internal Properties

    var didDeleteTap: VoidBlock?
    var didCancelTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var customView = AdditionalView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomView()
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
            $0.height.equalTo(114)
        }

        let indicatorView = UIView()
        indicatorView.snap(parent: customView) {
            $0.background(.gray(0.4))
            $0.clipCorners(radius: 2)
        } layout: {
            $0.top.equalTo($1).offset(6)
            $0.centerX.equalTo($1)
            $0.width.equalTo(31)
            $0.height.equalTo(4)
        }
    }

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClose))
        view.addGestureRecognizer(tap)
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: R.string.localizable.callListAlertTitle(),
            message: R.string.localizable.callListAlertText(),
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: R.string.localizable.callListAlertActionOne(),
                style: .default,
                handler: { _ in self.didClose() }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: R.string.localizable.callListAlertActionTwo(),
                style: .default,
                handler: { _ in self.didDeleteTap?() }
            )
        )
        present(alert, animated: true)
    }
}

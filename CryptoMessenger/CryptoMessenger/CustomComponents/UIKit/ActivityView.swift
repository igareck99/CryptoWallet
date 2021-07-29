import UIKit

// MARK: ActivityView

final class ActivityView: UIView {

    // MARK: - Private Properties

    private lazy var activityIndicatorView = UIActivityIndicatorView(frame: .zero)

    // MARK: - Lifecycle

    init(frame: CGRect, backgroundColor: UIColor?, tintColor: UIColor?) {
        super.init(frame: frame)

        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        addActivityIndicatorView()
        self.backgroundColor = backgroundColor ?? UIColor.black.withAlphaComponent(0.2)
        activityIndicatorView.color = .custom(tintColor ?? .white)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addActivityIndicatorView() {
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .large
        }
        activityIndicatorView.snap(parent: self, layout: {
            $0.center.equalTo($1)
        })
    }

    // MARK: - Public Methods

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }

    func isAnimating() -> Bool {
        return activityIndicatorView.isAnimating
    }

    static func hudIn(view: UIView) -> ActivityView? {
        return view.subviews.first(where: { $0 is ActivityView }) as? ActivityView
    }
}

import UIKit

// MARK: ActivityViewDisplayable

protocol ActivityViewDisplayable {
    func showActivity(animated: Bool)
    func showActivity(backgroundColor: UIColor?, tintColor: UIColor?, animated: Bool)
    func hideActivity(animated: Bool)
}

// MARK: - ActivityViewDisplayable (UIView)

extension ActivityViewDisplayable where Self: UIView {

    // MARK: - Public Methods

    func showActivity(animated: Bool) {
        showActivity(backgroundColor: nil, tintColor: nil, animated: animated)
    }

    func showActivity(backgroundColor: UIColor?, tintColor: UIColor?, animated: Bool) {
        guard ActivityView.hudIn(view: self) == nil else { return }

        let hudView = ActivityView(frame: .zero, backgroundColor: backgroundColor, tintColor: tintColor)
        addSubview(hudView)
        pinEdgesOf(hudView, to: self)
        hudView.startAnimating()
        if animated {
            UIView.animate(withDuration: 1, animations: {
                hudView.alpha = 1
            })
        } else {
            hudView.alpha = 1
        }
    }

    func hideActivity(animated: Bool) {
        guard let activity = ActivityView.hudIn(view: self) else { return }
        activity.stopAnimating()
        if animated {
            UIView.animate(withDuration: 1, animations: {
                activity.alpha = 0
            }, completion: { _ in
                activity.removeFromSuperview()
            })
        } else {
            activity.removeFromSuperview()
        }
    }

    // MARK: - Private Methods

    private func pinEdgesOf(_ view: UIView, to superView: UIView) {
        view.snap(parent: superView, layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        })
    }
}

// MARK: - UIView (ActivityViewDisplayable)
extension UIView: ActivityViewDisplayable {}

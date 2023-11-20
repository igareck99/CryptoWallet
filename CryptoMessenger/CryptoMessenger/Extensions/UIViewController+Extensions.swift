import UIKit

extension UIViewController {
    func presentToParentViewController(parent: UIViewController) {
        parent.addChild(self)
        parent.view.addSubview(self.view)
        self.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        self.view.transform = CGAffineTransform(translationX: parent.view.bounds.width, y: 0)
        UIView.animate(withDuration: 0.28, delay: 0.1, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { _ in
            self.didMove(toParent: parent)
        })
    }
    func dismissChildViewCont() {
        willMove(toParent: nil)
        self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.28, delay: 0.1, options: .curveEaseInOut, animations: {
            self.view.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        }, completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
}

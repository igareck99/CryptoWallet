// Igor Olnev 2019

import UIKit
//swiftlint:disable all
internal final class ActionSheetViewController: UIViewController {
    
    // MARK:
    
    var actionSheetView = IOActionSheetView()
    var didDisappear: (() -> Void)?
    lazy var titleLabel = UILabel()

    override func loadView() {
        super.loadView()
        
        view.addSubview(actionSheetView)
        actionSheetView.configure()
    }
    
    // MARK: - Private methods
    
    func appearAnimated() {
        var initialFrame = view.bounds
        initialFrame.origin.y += view.bounds.size.height
        self.actionSheetView.frame = initialFrame
        
        let targetFrame = view.bounds
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.2,
            options: [],
            animations: {
                self.actionSheetView.frame = targetFrame
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }) { _ in
        }

    }
    
    // MARK: - Public methods
    
    func disappearAnimated() {
        var targetFrame = view.bounds
        targetFrame.origin.y += view.bounds.size.height + (20.0)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.2,
            options: [],
            animations: {
                self.actionSheetView.frame = targetFrame
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { _ in
            self.didDisappear?()
        }
    }
}

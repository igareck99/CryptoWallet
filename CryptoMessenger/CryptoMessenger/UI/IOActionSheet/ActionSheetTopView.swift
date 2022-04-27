// Igor Olnev 2019

import UIKit

internal final class ActionSheetTopView: CustomView {
    
    // MARK: - Private
    
    private let blurView = UIVisualEffectView()
    private let arrow = UIImageView()
    
    // MARK: - Public
    
    var title = String()
    
    var imageViewCornerRadius = 500
    
    var artistTitle = UILabel()
    var artistTracksNumber = UILabel()
    
    override public class var preferredSize: CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    public override var intrinsicContentSize: CGSize {
        return ActionSheetTopView.preferredSize
    }
    
    override public func setup() {
        addSubview(blurView)
        blurView.effect = UIBlurEffect(style: .extraLight)
        blurView.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        blurView.isHidden = false
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        } 
    }
}

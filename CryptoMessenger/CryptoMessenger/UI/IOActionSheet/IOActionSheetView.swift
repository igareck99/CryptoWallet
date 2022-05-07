// Igor Olnev 2019

import UIKit
//swiftlint:disable all
final class IOActionSheetView: CustomView {
    // MARK: - Private
    
    private let topViewBlurEffect = UIVisualEffectView()
    private let cancelButtonBlurEffect = UIVisualEffectView()
    private let clearButtonBlurEffect = UIVisualEffectView()
    private var backgroundButton = UIButton()
    
    private var cancelButtonTitle = String()
    private var titleHeight = 0
    
    // MARK: - Public
    
    var imageURL = String()
    var buttonsCornerRadius: CGFloat = 15
    
    var buttonsBackgroundColor: UIColor? = .white
    
    // MARK: - IBOutlets
    
    var topView = ActionSheetTopView()
    var buttons: [ActionSheetButton] = []
    let cancelButtonView = UIView()
    var isTitle = false
    var titleText: String? = "" {
        didSet {
            if !((titleText?.count) != nil) {
                titleHeight = 0
            } else {
                titleHeight = 49
            }
            titleLabel.text = titleText
            titleLabel.sizeToFit()
        }
    }
    var cancelButton = UIButton()
    var cancelAction: (() -> Void)?
    
    var backgroundAction: (() -> Void)?
    let buttonsView = UIView()
    lazy var titleLabel = UILabel()

    override public class var preferredSize: CGSize {
        get {
            return UIScreen.main.bounds.size
        }
    }
    
    override public func setup() {
        frame = CGRect(origin: CGPoint.zero, size: type(of: self).preferredSize)
    }
    
    // MARK: - Public methods
    
    public func configure() {
        cancelButtonSetup()
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        gesture.direction = .down
        self.addGestureRecognizer(gesture)
        
        addSubview(topViewBlurEffect)
        topViewBlurEffect.effect = UIBlurEffect(style: .extraLight)
        topViewBlurEffect.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        topViewBlurEffect.layer.cornerRadius = buttonsCornerRadius
        topViewBlurEffect.layer.masksToBounds = true
        topViewBlurEffect.snp.makeConstraints { make in
            make.height.equalTo(58*buttons.count + titleHeight)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
        }
        
        buttonsListSetup()
    }
    
    public func cancelButtonInit(title: String, textColor: UIColor? = nil, backgroundColor: UIColor? = nil, font: UIFont) {
        cancelButtonTitle = title
        if backgroundColor == nil {
            cancelButton.backgroundColor = buttonsBackgroundColor
        } else {
            cancelButton.backgroundColor = backgroundColor
        }
        cancelButton.titleLabel?.font = font
        cancelButton.setTitleColor(textColor, for: .normal)
        cancelButton.setTitleColor(textColor?.withAlphaComponent(0.6), for: .highlighted)
    }
    
    // MARK: - Configurations
    
    fileprivate func cancelButtonSetup() {
        cancelButtonView.addSubview(cancelButtonBlurEffect)
        cancelButtonBlurEffect.effect = UIBlurEffect(style: .extraLight)
        cancelButtonBlurEffect.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        cancelButtonBlurEffect.layer.cornerRadius = buttonsCornerRadius
        cancelButtonBlurEffect.snp.makeConstraints { make in
            make.edges.equalTo(cancelButtonView)
        }
        
        addSubview(cancelButtonView)
        cancelButtonView.layer.cornerRadius = buttonsCornerRadius
        cancelButtonView.layer.masksToBounds = true
        cancelButtonView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottomMargin.equalToSuperview().offset(-10)
            make.height.equalTo(57)
        }
        
        addSubview(cancelButton)

        if cancelAction != nil {
            cancelButton.addTarget(self, action: #selector(clickHide), for: .touchUpInside)
        }
        
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.layer.cornerRadius = buttonsCornerRadius
        cancelButton.snp.makeConstraints { make in
            make.edges.equalTo(cancelButtonView)
        }
    }
    
    fileprivate func buttonsListSetup() {
        addSubview(buttonsView)
        buttonsView.backgroundColor = buttonsBackgroundColor
        buttonsView.layer.cornerRadius = buttonsCornerRadius
        buttonsView.layer.masksToBounds = true
        buttonsView.snp.makeConstraints { make in
            make.edges.equalTo(topViewBlurEffect)
        }
        
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.equalTo(buttonsView.snp.left)
            make.right.equalTo(buttonsView.snp.right)
            make.top.equalTo(buttonsView.snp.top).offset(titleHeight)

        }
        
        addButtonsOnView()
        titleLabel.textAlignment = .center
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonsView.snp.top).offset(50/2 - 6)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
    }
    
    private func addButtonsOnView() {
        var start = 1
        if titleText != nil {
            start = 0
        } else {
            topView.isHidden = false
        }
        
        for i in 0..<buttons.count {
            addSubview(buttons[i])
            
            if i >= start {
                buttons[i].addSeparator()
                buttons[i].clipsToBounds = true
            }
            
            buttons[i].snp.makeConstraints { make in
                if i == 0 {
                    make.height.equalTo(58)
                    make.top.equalTo(topView.snp.bottom)
                    make.left.equalTo(topView.snp.left)
                    make.right.equalTo(topView.snp.right)
                } else {
                    make.height.equalTo(58)
                    make.top.equalTo(buttons[i-1].snp.bottom)
                    make.left.equalTo(topView.snp.left)
                    make.right.equalTo(topView.snp.right)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    @objc private func clickHide(sender: UIButton) {
        cancelAction?()
    }
    
    @objc private func backgroundActionClick(sender: UIButton) {
        backgroundAction?()
    }
    
    @objc func handleGesture(_ sender: UISwipeGestureRecognizer? = nil) {
        backgroundAction?()
    }
}

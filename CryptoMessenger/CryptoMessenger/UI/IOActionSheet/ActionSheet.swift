// Igor Olnev 2019

import UIKit
//swiftlint:disable all
final class IOActionSheet {
    // MARK: - ViewController
    
    private var actionSheetViewController: ActionSheetViewController
    
    // MARK: - Private
    
    private var buttonColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    private var buttons = [ActionSheetButton]()
    private var window: UIWindow?
    
    // MARK: - Public
    
    public var imageURL = String()
    public var imageViewCornerRadius = 0
    public var cancelButtonTitle = ""
    public var cancelButtonTextColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    public var cancelButtonBackgroundColor: UIColor = UIColor.init(white: 1.0, alpha: 1)
    
    public var buttonsTextColor = UIColor.black
    public var backgroundColor: UIColor = UIColor.init(white: 0.2, alpha: 0.2)
    
    public var clearButtonTitle = String()
    public var clearButtonColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    public var clearButtonIcon = UIImage()
    public var clearButtonAction: (() -> Void)?
    
    public var buttonsFont: UIFont = UIFont.systemFont(ofSize: 17)
    public var cancelButtonFont: UIFont = UIFont.systemFont(ofSize: 17)
    
    public var isArrowHidden = true
    
    public var radius: CGFloat = 15
    
    // MARK: - IBOutlets

    private let topViewBlurEffect = UIVisualEffectView()
    private let cancelButtonBlurEffect = UIVisualEffectView()
    
    let buttonsView = UIView()
    
    public init(title: String? = nil, font: UIFont = UIFont.boldSystemFont(ofSize: 13), color: UIColor = .gray) {
        window = UIWindow()
        actionSheetViewController = ActionSheetViewController()
        if title != nil {
            actionSheetViewController.actionSheetView.titleText = title
            actionSheetViewController.actionSheetView.titleLabel.font = font
            actionSheetViewController.actionSheetView.titleLabel.textColor = color
        }
    }
    
    // MARK: - Private methods
    
    private func configure() {
        actionSheetViewController.actionSheetView.buttonsBackgroundColor = backgroundColor
        actionSheetViewController.actionSheetView.cancelButtonInit(title: cancelButtonTitle, textColor: cancelButtonTextColor, backgroundColor: cancelButtonBackgroundColor, font: cancelButtonFont)
        actionSheetViewController.actionSheetView.buttons = buttons
        actionSheetViewController.actionSheetView.imageURL = imageURL
        actionSheetViewController.actionSheetView.cancelAction = hide
        actionSheetViewController.actionSheetView.backgroundAction = hide
        actionSheetViewController.didDisappear = { [unowned self] in
            self.window = nil
        }
        actionSheetViewController.actionSheetView.buttonsCornerRadius = radius
    }
    
    // MARK: - Public methods
    
    // addButton
    /// Parameters descriptions for add an Action
    ///
    /// - parameter title: Title of the action, will rapresent on the button view
    /// - parameter font: Font used for the title rapresenting. Defaul option uses buttonsFont parameter configuration
    /// - parameter color: Color used for title text color. Default parameter is darkGray
    /// - parameter action: To use for call an action.
    public func addButton(title: String, font: UIFont? = UIFont.systemFont(ofSize: 17), color: UIColor? = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), action: @escaping (() -> Void)) {
        
        let button = ActionSheetButton()
        button.titleText = title

        button.title.font = font ?? buttonsFont
        button.title.textColor = color
        
        button.action = action
        button.hide = hide
        
        button.configure()
        buttons.append(button)
    }
    
    public func show() {
        configure()
        
        let screenFrame = UIScreen.main.bounds
        window = UIWindow(frame: screenFrame)
        window?.windowLevel = UIWindow.Level.statusBar
        
        self.window?.rootViewController = self.actionSheetViewController
        self.window?.makeKeyAndVisible()
        
        actionSheetViewController.appearAnimated()
    }
    
    public func hide() {
        actionSheetViewController.disappearAnimated()
    }
}

// Customs
open class CustomView: UIView {
    /// Override
    open class var preferredSize: CGSize {
        get {
            return CGSize.zero
        }
    }
    
    /// Override
    open func setup() {
        fatalError("Must override setup")
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        frame = CGRect(origin: CGPoint.zero, size: type(of: self).preferredSize)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

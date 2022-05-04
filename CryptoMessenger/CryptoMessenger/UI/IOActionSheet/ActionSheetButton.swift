import UIKit

open class ActionSheetButton: UIButton {    
    // MARK: - Private properties

    public var titleText: String? {
        didSet {
            title.text = titleText
        }
    }

    public var action: (() -> Void)?
    public var hide: (() -> Void)?
    // MARK: - Outlets
    public var title = UILabel()
    open class var preferredSize: CGSize {
        get {
            return CGSize(width: 0, height: 58)
        }
    }

    // MARK: - Public methods
    public func configure() {
        title.textAlignment = .center
        addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-19)
        }
    }
    public func addSeparator() {
        addSeparatorOnTop()
    }
    // MARK: - Private methods
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.preciseLocation(in: self) {
            if (point.y < 0 || point.y > frame.height) || (point.x < 0) || (point.x > frame.width) {
                backgroundColor = .clear
            }
        }
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.preciseLocation(in: self) {
            if !((point.y < 0 || point.y > frame.height) || (point.x < 0) || (point.x > frame.width)) {
                action?()
                hide?()
            }
        }
        backgroundColor = .clear
    }
}

extension UIView {
    func addSeparatorOnTop() {
        let separator = UIView()
        addSubview(separator)
        separator.backgroundColor = UIColor.lightGray
        separator.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(0.5)
            make.width.equalToSuperview()
        }
    }
    func addSeparatorOnBottom() {
        let separator = UIView()
        addSubview(separator)
        separator.backgroundColor = UIColor.lightGray
        separator.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-0.5)
            make.height.equalTo(0.5)
            make.width.equalToSuperview()
        }
    }
}

import UIKit

// MARK: - LoadingButton

class LoadingButton: UIButton {

    // MARK: - Internal Variables

    var isLoading = false
    var indicator: UIView & IndicatorProtocol = UIActivityIndicatorView()
    var cornerRadius: CGFloat = 8 {
        didSet {
            clipsToBounds = self.cornerRadius > 0
            layer.cornerRadius = self.cornerRadius
        }
    }

    var bgColor: Palette = .lightBlue() {
        didSet {
            backgroundColor = bgColor.uiColor
        }
    }

    // MARK: - Private Variables

    private var loaderWorkItem: DispatchWorkItem?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
    }

    // MARK: - Internal Methods

    func showLoader(userInteraction: Bool, _ completion: VoidBlock? = nil) {
        showLoader([titleLabel, imageView], userInteraction: userInteraction, completion)
    }

    func showLoaderWithImage(userInteraction: Bool = false) {
        showLoader([titleLabel], userInteraction: userInteraction)
    }

    func showLoader(_ viewsToBeHidden: [UIView?], userInteraction: Bool = false, _ completion: VoidBlock? = nil) {
        guard !subviews.contains(indicator) else { return }

        isLoading = true
        isUserInteractionEnabled = userInteraction
        indicator.radius = min(0.7 * frame.height * 0.5, indicator.radius)
        indicator.alpha = 0.0
        addSubview(indicator)

        loaderWorkItem?.cancel()
        loaderWorkItem = nil

        loaderWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
            UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
                viewsToBeHidden.forEach { $0?.alpha = 0 }
                self.indicator.alpha = 1
            }, completion: { _ in
                guard !item.isCancelled else { return }
                self.isLoading ? self.indicator.startAnimating() : self.hideLoader()
                completion?()
            })
        }
        loaderWorkItem?.perform()
    }

    func hideLoader(_ completion: VoidBlock? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard self.subviews.contains(self.indicator) else { return }

            self.isLoading = false
            self.isUserInteractionEnabled = true
            self.indicator.stopAnimating()

            self.indicator.removeFromSuperview()
            self.loaderWorkItem?.cancel()
            self.loaderWorkItem = nil

            self.loaderWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
                UIView.transition(with: self, duration: 0.2, options: .curveEaseIn, animations: {
                    self.titleLabel?.alpha = 1
                    self.imageView?.alpha = 1
                }, completion: { _ in
                    guard !item.isCancelled else { return }
                    completion?()
                })
            }
            self.loaderWorkItem?.perform()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let color: Palette = bgColor == .clear ? .lightBlue() : bgColor
        backgroundColor = color.uiColor
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = bgColor.uiColor
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        backgroundColor = bgColor.uiColor
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let color: Palette = bgColor == .clear ? .lightBlue() : bgColor
        backgroundColor = color.uiColor
    }
}

// MARK: - UIActivityIndicatorView (IndicatorProtocol)

extension UIActivityIndicatorView: IndicatorProtocol {
    var radius: CGFloat {
        get { frame.width * 0.5 }
        set {
            frame.size = CGSize(width: 2 * newValue, height: 2 * newValue)
            setNeedsDisplay()
        }
    }

    var color: Palette {
        get { .custom(tintColor) }
        set {
            style = .medium
            tintColor = newValue.uiColor
        }
    }

    func setupAnimation(in layer: CALayer, size: CGSize) {}
}

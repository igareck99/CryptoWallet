import SwiftUI
import UIKit

protocol PinchZoomViewDelgate: AnyObject {
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangePinching isPinching: Bool)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeScale scale: CGFloat)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeAnchor anchor: UnitPoint)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeOffset offset: CGSize)
}

class PinchZoomView: UIView {
    private(set) var scale: CGFloat = 0 {
        didSet {
            delegate?.pinchZoomView(self, didChangeScale: scale)
        }
    }

    private(set) var anchor: UnitPoint = .center {
        didSet {
            delegate?.pinchZoomView(self, didChangeAnchor: anchor)
        }
    }

    private(set) var offset: CGSize = .zero {
        didSet {
            delegate?.pinchZoomView(self, didChangeOffset: offset)
        }
    }

    private(set) var isPinching = false {
        didSet {
            delegate?.pinchZoomView(self, didChangePinching: isPinching)
        }
    }

    private var startLocation: CGPoint = .zero
    private var location: CGPoint = .zero
    private var numberOfTouches: Int = 0
    weak var delegate: PinchZoomViewDelgate?

    init() {
        super.init(frame: .zero)
        addGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implamented")
    }

    // MARK: - Private Methods

    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(
            target: self,
            action: #selector(pinch(gesture:))
        )
        pinchGesture.cancelsTouchesInView = false
        addGestureRecognizer(pinchGesture)
    }

    @objc private func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            onGestureBegan(gesture: gesture)
        case .changed:
            onGestureChanged(gesture: gesture)
        case .ended, .cancelled, .failed:
            onGestureEnd(gesture: gesture)
        default:
            break
        }
    }

    private func onGestureBegan(gesture: UIPinchGestureRecognizer) {
        isPinching = true
        startLocation = gesture.location(in: self)
        anchor = UnitPoint(x: startLocation.x / bounds.width, y: startLocation.y / bounds.height)
        numberOfTouches = gesture.numberOfTouches
    }

    private func onGestureChanged(gesture: UIPinchGestureRecognizer) {
        if gesture.numberOfTouches != numberOfTouches {
            // If the number of fingers being used changes, the start location needs to be adjusted to avoid jumping.
            let newLocation = gesture.location(in: self)
            let jumpDifference = CGSize(
                width: newLocation.x - location.x,
                height: newLocation.y - location.y
            )
            startLocation = CGPoint(
                x: startLocation.x + jumpDifference.width,
                y: startLocation.y + jumpDifference.height
            )
            numberOfTouches = gesture.numberOfTouches
        }
        scale = gesture.scale
        location = gesture.location(in: self)
        offset = CGSize(width: location.x - startLocation.x, height: location.y - startLocation.y)
    }

    private func onGestureEnd(gesture: UIPinchGestureRecognizer) {
        withAnimation(.interactiveSpring()) {
            isPinching = false
            scale = 1.0
            anchor = .center
            offset = .zero
        }
    }
}

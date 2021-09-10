import UIKit

// MARK: - ScrollAnimation

final class ScrollAnimation: NSObject {

    // MARK: - Internal Properties

    let preview: PreviewLayout
    let thumbnails: ThumbnailLayout
    let type: Type

    // MARK: - Lifecycle

    init(thumbnails: ThumbnailLayout, preview: PreviewLayout, type: Type) {
        self.preview = preview
        self.thumbnails = thumbnails
        self.type = type
        super.init()
    }

    // MARK: - Internal Methods

    func run(completion: @escaping () -> Void) {
        let toValue: CGFloat = self.type == .beign ? 0 : 1
        let currentExpanding = thumbnails.config.expandingRate
        let duration = TimeInterval(0.15 * abs(currentExpanding - toValue))

        let animator = Animator(onProgress: { current, _ in
            let rate = currentExpanding + (toValue - currentExpanding) * current
            self.thumbnails.config.expandingRate = rate
            self.thumbnails.invalidateLayout()
        }, easing: .easeInOut)

        animator.animate(duration: duration) { _ in
            completion()
        }
    }
}

extension ScrollAnimation {

    enum `Type` {
        case beign
        case end
    }
}

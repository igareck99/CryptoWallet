import UIKit

// MARK: - ScrollAnimation

final class ScrollAnimation: NSObject {

    // MARK: - State

    enum State {
        case begin
        case end
    }

    // MARK: - Internal Properties

    let preview: PreviewLayout
    let thumbnails: ThumbnailLayout
    let state: State

    // MARK: - Lifecycle

    init(thumbnails: ThumbnailLayout, preview: PreviewLayout, state: State) {
        self.preview = preview
        self.thumbnails = thumbnails
        self.state = state
        super.init()
    }

    // MARK: - Internal Methods

    func run(completion: @escaping () -> Void) {
        let toValue: CGFloat = state == .begin ? 0 : 1
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

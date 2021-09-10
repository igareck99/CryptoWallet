import UIKit

// MARK: - ThumbnailLayout.Configuration

extension ThumbnailLayout {
    struct Configuration {

        // MARK: - Internal Properties

        let maxAspectRatio: CGFloat = 5
        let minAspectRatio: CGFloat = 0.2
        let defaultAspectRatio: CGFloat = 0.5

        let distanceBetween: CGFloat = 4
        let distanceBetweenFocused: CGFloat = 20

        var expandingRate: CGFloat = 1
        var updates: [IndexPath: CellUpdate] = [:]
    }
}

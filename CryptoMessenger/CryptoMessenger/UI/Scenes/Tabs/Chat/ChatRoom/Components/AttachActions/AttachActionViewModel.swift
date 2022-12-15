import SwiftUI
import Photos

// swiftlint: disable: empty_count

// MARK: - AttachActionViewModel

final class AttachActionViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var isTransactionAvailable = false
    @Published var images: [UIImage] = []
    @Injectable private(set) var togglesFacade: MainFlowTogglesFacade

    // MARK: - Lifecycle

    init() {
        fetchChatData()
        fetchPhotos()
    }

    // MARK: - Private Methods

    private func fetchChatData() {
        isTransactionAvailable = togglesFacade.isTransactionAvailable
    }

    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        if fetchResult.count > 0 {
            let totalImageCountNeeded = 50
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }

    private func fetchPhotoAtIndex(_ index: Int,
                                   _ totalImageCountNeeded: Int,
                                   _ fetchResult: PHFetchResult<PHAsset>) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .exact
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset,
                                              targetSize: CGSize(width: UIScreen.main.bounds.width,
                                                                 height: UIScreen.main.bounds.width),
                                              contentMode: PHImageContentMode.aspectFit,
                                              options: requestOptions,
                                              resultHandler: { image, _ in
            if let image = image {
                self.images += [image]
            }
            if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                debugPrint("Completed array: \(self.images)")
            }
        })
    }
}

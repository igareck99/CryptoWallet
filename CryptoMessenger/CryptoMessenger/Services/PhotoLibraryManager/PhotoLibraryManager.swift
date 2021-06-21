import AVFoundation
import Photos
import UIKit

// MARK: PhotoLibraryManager

final class PhotoLibraryManager: NSObject {

    // MARK: - Internal Properties

    let library = PHPhotoLibrary.shared()

    // MARK: - Type

    typealias AssetCompletion = (PHAsset?) -> Void

    // MARK: - Internal Methods

    func save(
        image: UIImage,
        albumName: String?,
        date: Date = Date(),
        location: CLLocation? = nil,
        completion: AssetCompletion? = nil
    ) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            saveImage(
                image: image,
                albumName: albumName,
                date: date,
                location: location,
                completion: completion
            )
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.saveImage(
                        image: image,
                        albumName: albumName,
                        date: date,
                        location: location,
                        completion: completion
                    )
                }
            }
        }
    }

    func save(
        videoAtURL: URL,
        albumName: String?,
        date: Date = Date(),
        location: CLLocation? = nil,
        completion: ((PHAsset?) -> Void
        )? = nil) {

        if PHPhotoLibrary.authorizationStatus() == .authorized {
            saveVideo(
                videoAtURL: videoAtURL,
                albumName: albumName,
                date: date,
                location: location,
                completion: completion
            )
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.saveVideo(
                        videoAtURL: videoAtURL,
                        albumName: albumName,
                        date: date,
                        location: location,
                        completion: completion
                    )
                }
            }
        }
    }

    func getAlbum(name: String, completion: @escaping (PHAssetCollection) -> Void) {
        if let album = self.findAlbum(name: name) {
            completion(album)
        } else {
            createAlbum(name: name, completion: completion)
        }
    }

    // MARK: - Private Methods

    private func findAlbum(name: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: fetchOptions
        )
        guard let photoAlbum = fetchResult.firstObject else { return nil }
        return photoAlbum
    }

    private func createAlbum(name: String, completion: @escaping (PHAssetCollection) -> Void) {
        var placeholder: PHObjectPlaceholder?

        library.performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { _, _ in
            let fetchResult = PHAssetCollection.fetchAssetCollections(
                withLocalIdentifiers: [placeholder!.localIdentifier],
                options: nil
            )
            completion(fetchResult.firstObject!)
        })
    }

    private func saveImage(
        imageAtURL: URL,
        album: PHAssetCollection?,
        date: Date = Date(),
        location: CLLocation? = nil,
        completion: ((PHAsset?) -> Void)? = nil
    ) {
        var placeholder: PHObjectPlaceholder?
        library.performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageAtURL)!
            createAssetRequest.creationDate = date
            createAssetRequest.location = location
            if let album = album {
                guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                    let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
                placeholder = photoPlaceholder
                let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
                albumChangeRequest.addAssets(fastEnumeration)
            }
        }, completionHandler: { success, _ in
            guard let placeholder = placeholder else { return }
            if success {
                let assets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(
                    withLocalIdentifiers: [placeholder.localIdentifier],
                    options: nil
                )
                let asset: PHAsset? = assets.firstObject
                completion?(asset)
            }
        })
    }

    private func saveVideo(
        videoAtURL: URL,
        albumName: String?,
        date: Date = Date(),
        location: CLLocation? = nil,
        completion: AssetCompletion? = nil
    ) {
        var placeholder: PHObjectPlaceholder?

        library.performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoAtURL)!
            createAssetRequest.creationDate = date
            createAssetRequest.location = location
            if let albumName = albumName {
                self.getAlbum(name: albumName) { album in
                    guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                        let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
                    placeholder = photoPlaceholder
                    let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
                    albumChangeRequest.addAssets(fastEnumeration)
                }
            }
        }, completionHandler: { success, _ in
            guard let placeholder = placeholder else {
                completion?(nil)
                return
            }

            if success {
                let assets: PHFetchResult<PHAsset> =  PHAsset.fetchAssets(
                    withLocalIdentifiers: [placeholder.localIdentifier],
                    options: nil
                )
                let asset: PHAsset? = assets.firstObject
                completion?(asset)
            } else {
                completion?(nil)
            }
        })
    }

    private func saveImage(
        image: UIImage,
        albumName: String?,
        date: Date = Date(),
        location: CLLocation? = nil,
        completion: AssetCompletion? = nil
    ) {
        var placeholder: PHObjectPlaceholder?

        library.performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            createAssetRequest.creationDate = date
            createAssetRequest.location = location
            if let albumName = albumName {
                self.getAlbum(name: albumName) { album in
                    guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                        let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
                    placeholder = photoPlaceholder
                    let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
                    albumChangeRequest.addAssets(fastEnumeration)
                }
            }
        }, completionHandler: { success, _ in
            guard let placeholder = placeholder else {
                completion?(nil)
                return
            }
            if success {
                let assets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(
                    withLocalIdentifiers: [placeholder.localIdentifier],
                    options: nil
                )
                let asset: PHAsset? = assets.firstObject
                completion?(asset)
            } else {
                completion?(nil)
            }
        })
    }
}

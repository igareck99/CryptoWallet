import Foundation
import Photos

protocol PhotosAccessProtocol {
    var photoAccessLevel: PhotoAccessLevel { get }

    func getPhotoAccessLevel() -> PhotoAccessLevel
    func requestPhotoAccess(completion: @escaping (PhotoAccessLevel) -> Void)
}

protocol MediaAccessProtocol {

    var videoAccessLevel: MediaAccessLevel { get }

    func getVideoAccessLevel() -> MediaAccessLevel
    func requestVideoAccess(completion: @escaping (Bool) -> Void)

    var audioAccessLevel: MediaAccessLevel { get }

    func getAudioAccessLevel() -> MediaAccessLevel
    func requestAudioAccess(completion: @escaping (Bool) -> Void)
}

protocol LocationAccessProtocol {
    var locationAcessLevel: LocationAccessLevel { get }
    // auth type always
    func requestLocationAuthorization()
    func getLocationAccessLevel() -> LocationAccessLevel
}

final class AccessService: NSObject {

    let locationManager = CLLocationManager()
    let phPhotoLibrary = PHPhotoLibrary.shared()
    static let shared = AccessService()

    var videoAccessLevel: MediaAccessLevel = .notDetermined
    var audioAccessLevel: MediaAccessLevel = .notDetermined
    var photoAccessLevel: PhotoAccessLevel = .notDetermined
    var locationAcessLevel: LocationAccessLevel = .notDetermined

    override init() {
        super.init()
        phPhotoLibrary.register(self)
        locationManager.delegate = self
        updateAccessLevels()
    }

    private func updateAccessLevels() {
        audioAccessLevel = getAudioAccessLevel()
        videoAccessLevel = getVideoAccessLevel()
        photoAccessLevel = getPhotoAccessLevel()
        locationAcessLevel = getLocationAccessLevel()
    }
}

// MARK: - LocationAccessProtocol

extension AccessService: LocationAccessProtocol {
    func getLocationAccessLevel() -> LocationAccessLevel {
        let status = locationManager.authorizationStatus
        debugPrint("requestLocationAccess: \(status)")
        let accessLevel = locationAccessLevel(from: status)
        return accessLevel
    }

    func requestLocationAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate

extension AccessService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        debugPrint("locationManagerDidChangeAuthorization: \(manager)")
        let accessLevel = locationAccessLevel(from: manager.authorizationStatus)
        locationAcessLevel = accessLevel
        NotificationCenter.default.post(
            name: .locationAccessLevelDidChange,
            object: [
                "accessLevel": "\(accessLevel)"
            ]
        )
    }
}

// MARK: - PhotosAccessProtocol

extension AccessService: PhotosAccessProtocol {

    func getPhotoAccessLevel() -> PhotoAccessLevel {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        let accessLevel = photoAccessLevel(from: status)
        return accessLevel
    }

    func requestPhotoAccess(completion: @escaping (PhotoAccessLevel) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            debugPrint("requestPhotoAccess: \(status)")
            guard let self = self else { return }
            let accessLevel = self.photoAccessLevel(from: status)
            completion(accessLevel)
        }
    }
}

// MARK: - PHPhotoLibraryAvailabilityObserver

extension AccessService: PHPhotoLibraryAvailabilityObserver {
    func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {
        debugPrint("photoLibraryDidBecomeUnavailable: \(photoLibrary)")
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        let accessLevel = photoAccessLevel(from: status)
        photoAccessLevel = accessLevel
        NotificationCenter.default.post(
            name: .photoAccessLevelDidChange,
            object: [
                "accessLevel": "\(accessLevel)",
                "PHAccessLevel": "\(PHAccessLevel.readWrite)"
            ]
        )
    }
}

// MARK: - MediaAccessProtocol

extension AccessService: MediaAccessProtocol {

    func getVideoAccessLevel() -> MediaAccessLevel {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        let accessLevel = mediaAccessLevel(from: status)
        return accessLevel
    }

    func requestVideoAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { status in
            debugPrint("requestVideoAccess: \(status)")
            completion(status)
        }
    }

    func getAudioAccessLevel() -> MediaAccessLevel {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        let accessLevel = mediaAccessLevel(from: status)
        return accessLevel
    }

    func requestAudioAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { status in
            debugPrint("requestAudioAccess: \(status)")
            completion(status)
        }
    }
}

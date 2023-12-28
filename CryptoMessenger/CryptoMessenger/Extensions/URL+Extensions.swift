import AVFoundation
import SwiftUI

// MARK: - URL ()

extension URL {

    static let mock = URL(string: "https://matrix.aura.ms/")!

    // MARK: - Internal Methods

    func fileSize() async -> String {
        let attribute = try? FileManager.default.attributesOfItem(atPath: path)
        guard let size = attribute?[.size] as? NSNumber else { return "0.0 MB" }
        return "\(size.doubleValue / 1000000.0) MB"
    }

    func isReachable() async -> Bool {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        let response = try? await URLSession.shared.data(for: request)
        let result = (response?.1 as? HTTPURLResponse)?.statusCode == 200
        return result
    }

    func generateThumbnail() async -> UIImage? {
        let asset = AVURLAsset(url: self, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMake(value: 0, timescale: 1)
        guard let cgImage = try? imgGenerator.copyCGImage(at: time, actualTime: nil) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    func getThumbnailImage() async -> Image? {
        guard let data = try? await URLSession.shared.data(from: self).0,
              let image = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: image)
    }

    // MARK: - Internal Properties

    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}

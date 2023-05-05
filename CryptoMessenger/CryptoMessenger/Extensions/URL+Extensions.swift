import SwiftUI
import AVFoundation

// MARK: - URL ()

extension URL {

    // MARK: - Internal Methods

    func fileSize() -> String {
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: path)
            if let size = attribute[.size] as? NSNumber {
                return "\(size.doubleValue / 1000000.0) MB"
            }
        } catch {
            debugPrint("Error: \(error)")
        }
        return "0.0 MB"
    }

    func isReachable(completion: @escaping (Bool) -> Void) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
        }.resume()
    }

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        do {
            let asset = AVURLAsset(url: self, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            completion(thumbnail)
        } catch let error {
            print("Error generating thumbnail: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func getThumbnailImage(completion: @escaping (Image?) -> Void ) {
        let dataTask = URLSession.shared.dataTask(with: self) {  data, _, _ in
            if let data = data {
                guard let image = UIImage(data: data) else { return }
               completion(Image(uiImage: image))
            } else {
                completion(nil)
            }
        }
        dataTask.resume()
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

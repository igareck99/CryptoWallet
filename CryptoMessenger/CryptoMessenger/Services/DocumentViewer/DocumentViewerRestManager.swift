import Foundation


final class DocumentViewerRestManager {
    func quickLook(url: URL,
                   completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            guard
                let httpURLResponse = response as? HTTPURLResponse
            else {
                print((response as? HTTPURLResponse)?.mimeType ?? "")
                completion(nil)
                return
            }
            do {
                let suggestedFilename = httpURLResponse.suggestedFilename ?? "quicklook.pdf"
                var previewURL = FileManager.default.temporaryDirectory.appendingPathComponent(suggestedFilename)
                try data.write(to: previewURL, options: .atomic)
                completion(previewURL)
            } catch {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
}

import SwiftUI
import Combine

// MARK: - VideoViewModel

final class VideoViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var videoUrl: URL?
    @Published var thumbnailUrl: URL?
    @Published var dataUrl: URL?

    // MARK: - Lifecycle

    init(videoUrl: URL?,
         thumbnailUrl: URL?) {
        self.videoUrl = videoUrl
        self.thumbnailUrl = thumbnailUrl
    }

    // MARK: - Private Properties

    func downloadVideo(completion: @escaping (URL?) -> Void) {
        guard let video = self.videoUrl else { return }
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                         in: .userDomainMask)[0]
        URLSession.shared.downloadTask(with: video) { tempFileUrl, _, _ in
               if let imageTempFileUrl = tempFileUrl {
                   do {
                       let imageData = try Data(contentsOf: imageTempFileUrl)
                       let videoName = documentDirectory.appendingPathComponent(tempFileUrl?.absoluteString ?? "")
                       try imageData.write(to: videoName)
                       completion(videoName)
                   } catch {
                       completion(nil)
                   }
               }
           }.resume()
    }
    
    private func downloadFile(withUrl url: URL,
                              andFilePath filePath: URL,
                              completion: @escaping ((_ filePath: URL?) -> Void)) {
        do {
            let data = try Data(contentsOf: url)
            try data.write(to: filePath, options: .noFileProtection)
            completion(filePath)
        } catch {
            debugPrint("an error happened while downloading or saving the file")
            completion(nil)
        }
    }
    
    private func checkBookFileExists(withLink link: String,
                                     completion: @escaping ((_ filePath: URL?) -> Void)) {
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url = URL(string: urlString ?? "") {
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false) {
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent + ".mp4", isDirectory: false)
                do {
                    if try filePath.checkResourceIsReachable() {
                        debugPrint("file exist")
                        deleteRecording(urlsToDelete: [filePath])
                        downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                    } else {
                        debugPrint("file doesnt exist")
                        debugPrint(filePath)
                        downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                    }
                } catch {
                    debugPrint("file doesnt exist")
                    debugPrint(filePath)
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            } else {
                debugPrint("file doesnt exist")
                completion(nil)
            }
        } else {
            debugPrint("file doesnt exist")
            completion(nil)
        }
    }

    func setupAudioNew(completion: @escaping ((_ filePath: URL?) -> Void)) {
        guard let downloadUrl = videoUrl else {
            debugPrint("Ошибка загрузки аудио файла")
            completion(nil)
            return
        }
        checkBookFileExists(withLink: downloadUrl.absoluteString) { filePath in
            completion(filePath)
        }
    }
    
    private func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                debugPrint("File could not be deleted!")
            }
        }
    }
}

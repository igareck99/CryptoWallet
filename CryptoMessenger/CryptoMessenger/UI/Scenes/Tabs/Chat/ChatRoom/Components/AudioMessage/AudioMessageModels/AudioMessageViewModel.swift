import SwiftUI
import AVFoundation
import Combine

// swiftlint:disable all

// MARK: - AudioMessageViewModel

final class AudioMessageViewModel: ObservableObject {

    // MARK: - Internal properties

    var url: URL?

    @Published var downloadError = false
    @Published var isUpload = false
    @Published var endPlaying = false

    // MARK: - Lifecycle

    init(url: URL?) {
        self.url = url
    }

    // MARK: - Internal Methods

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
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent + ".m4a", isDirectory: false)
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
        isUpload = true
        guard let downloadUrl = url else {
            debugPrint("Ошибка загрузки аудио файла")
            downloadError = true
            completion(nil)
            return
        }
        checkBookFileExists(withLink: downloadUrl.absoluteString) { filePath in
            completion(filePath)
        }
    }

    func clearData() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let directoryContents = try fileManager
                                    .contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for item in directoryContents {
                deleteRecording(urlsToDelete: [item])
            }
        } catch {
            debugPrint("Error while clear directory")
        }
    }

    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                debugPrint("File could not be deleted!")
            }
        }
    }
    
    
}

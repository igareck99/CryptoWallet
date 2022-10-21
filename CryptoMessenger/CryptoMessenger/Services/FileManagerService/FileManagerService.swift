import Foundation

// MARK: - FileStates

enum FileStates {

    case exist(URL)
    case notExist(URL)
    case error
}

// MARK: - FileManagerProtocol

protocol FileManagerProtocol {

    func checkBookFileExists(withLink link: String,
                             fileExtension: String,
                             completion: @escaping ((FileStates) -> Void))
    func deleteRecording(urlsToDelete: [URL])
}

// MARK: - FileManagerService

final class FileManagerService: FileManagerProtocol, ObservableObject {

    // MARK: - Static Properties

    static let shared = FileManagerService()

    // MARK: - Internal Methods

    func checkBookFileExists(withLink link: String,
                             fileExtension: String,
                             completion: @escaping ((FileStates) -> Void)) {
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url = URL(string: urlString ?? "") {
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory,
                                                            in: .userDomainMask,
                                                            appropriateFor: nil,
                                                            create: false) {
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent + fileExtension,
                                                                        isDirectory: false)
                do {
                    if try filePath.checkResourceIsReachable() {
                        debugPrint("File exist")
                        completion(.exist(filePath))
                    } else {
                        debugPrint("File doesnt exist")
                        completion(.notExist(filePath))
                    }
                } catch {
                    debugPrint("File doesnt exist")
                    completion(.notExist(filePath))
                }
            } else {
                debugPrint("File doesnt exist")
                completion(.error)
            }
        } else {
            debugPrint("File doesnt exist")
            completion(.error)
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

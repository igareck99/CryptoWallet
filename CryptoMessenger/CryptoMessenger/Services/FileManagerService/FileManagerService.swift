import SwiftUI

// MARK: - FileStates

enum FileStates: Equatable {

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
    func checkFileExist(name: String, pathExtension: String) -> (Bool, URL?)
    func saveFile(name: String, data: Data, pathExtension: String) -> URL?
    func getFileSize(_ path: String) -> String
    func clearDocumentDirectory()
    func getImageFile(_ path: String, _ pathExtension: String) -> Image?
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
    
    func checkFileExist(name: String, pathExtension: String) -> (Bool, URL?) {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var filePath = documentDirectory.appendingPathComponent(name,
                                                                isDirectory: false)
        filePath.appendPathExtension(pathExtension)
        do {
            let isReachable = try filePath.checkResourceIsReachable()
            return (true, filePath)
        } catch {
            return (false, nil)
        }
    }

    func saveFile(name: String, data: Data, pathExtension: String) -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var filePath = documentDirectory.appendingPathComponent(name,
                                                                isDirectory: false)
        filePath.appendPathExtension(pathExtension)
        print("SaveFilePath  \(filePath)")
        do {
            try data.write(to: filePath, options: .noFileProtection)
        } catch {
            debugPrint("Write File Error  \(error)")
        }
        return filePath
    }

    func getFileSize(_ path: String) -> String {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let attribute = try? FileManager.default.attributesOfItem(atPath: path)
        guard let size = fileManager.sizeOfFile(atPath: path) else { return "" }
        let bcf = ByteCountFormatter()
        bcf.countStyle = .decimal
        bcf.allowedUnits = [.useKB, .useMB, .useGB, .useBytes]
        return bcf.string(fromByteCount: size)
    }
    
    func getImageFile(_ path: String, _ pathExtension: String) -> Image? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var filePath = documentDirectory.appendingPathComponent(path,
                                                                isDirectory: false)
        filePath.appendPathExtension(pathExtension)
        guard let uiImage = UIImage(contentsOfFile: filePath.path()) else { return nil }
        return Image(uiImage: uiImage)
    }

    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            do {
                try FileManager.default.removeItem(at: url)
                debugPrint("File at \(url) was delete")
            } catch {
                debugPrint("File could not be deleted!")
            }
        }
    }
    
    func clearDocumentDirectory() {
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
}

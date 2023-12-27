import SwiftUI

// MARK: - FileStates

enum FileStates: Equatable {

    case exist(URL)
    case notExist(URL)
    case error
}

// MARK: - FileManagerProtocol

protocol FileManagerProtocol {

    func checkBookFileExists(
        withLink link: String,
        fileExtension: String
    ) async -> FileStates
    func deleteRecording(urlsToDelete: [URL]) async
    func checkFileExist(name: String, pathExtension: String) async -> (Bool, URL?)
    func saveFile(name: String, data: Data, pathExtension: String) async -> URL?
    func getFileSize(path: String) async -> String
    func clearDocumentDirectory() async
    func getImageFile(path: String, pathExtension: String) async -> Image?
}

// MARK: - FileManagerService

final class FileManagerService: FileManagerProtocol {

    // MARK: - Static Properties

    static let shared = FileManagerService()

    // MARK: - Internal Methods

    func checkBookFileExists(
        withLink link: String,
        fileExtension: String
    ) async -> FileStates {
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: urlString ?? "") else {
            return .error
        }
        let fileManager = FileManager.default
        guard let documentDirectory = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) else {
            return .error
        }
        let filePath = documentDirectory.appendingPathComponent(
            url.lastPathComponent + fileExtension,
            isDirectory: false
        )
        guard (try? filePath.checkResourceIsReachable()) == true else {
            return .notExist(filePath)
        }
        return .exist(filePath)
    }

    func checkFileExist(name: String, pathExtension: String) async -> (Bool, URL?) {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var filePath = documentDirectory.appendingPathComponent(name, isDirectory: false)
        filePath.appendPathExtension(pathExtension)

        guard let isReachable = try? filePath.checkResourceIsReachable() else {
            return (false, nil)
        }
        return (isReachable, filePath)
    }

    func saveFile(name: String, data: Data, pathExtension: String) async -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var filePath = documentDirectory.appendingPathComponent(name, isDirectory: false)
        filePath.appendPathExtension(pathExtension)
        debugPrint("SaveFilePath  \(filePath)")
        try? data.write(to: filePath, options: .noFileProtection)
        return filePath
    }

    func getFileSize(path: String) async -> String {
        guard let size = FileManager.default.sizeOfFile(atPath: path) else { return "" }
        let bcf = ByteCountFormatter()
        bcf.countStyle = .decimal
        bcf.allowedUnits = [.useKB, .useMB, .useGB, .useBytes]
        return bcf.string(fromByteCount: size)
    }

    func getImageFile(path: String, pathExtension: String) async -> Image? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var filePath = documentDirectory.appendingPathComponent(path, isDirectory: false)
        filePath.appendPathExtension(pathExtension)
        guard let uiImage = UIImage(contentsOfFile: filePath.path()) else { return nil }
        return Image(uiImage: uiImage)
    }

    func deleteRecording(urlsToDelete: [URL]) async {
        urlsToDelete.forEach { url in
            try? FileManager.default.removeItem(at: url)
        }
    }

    func clearDocumentDirectory() async {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first,
              let directoryContents = try? fileManager.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
              ) else {
            return
        }
        for item in directoryContents {
            await deleteRecording(urlsToDelete: [item])
        }
    }
}

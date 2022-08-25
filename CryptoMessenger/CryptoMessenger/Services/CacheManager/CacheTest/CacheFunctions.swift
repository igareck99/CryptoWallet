import Foundation

func cacheFileUrl(_ fileName: String) -> URL {
    let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return cacheURL.appendingPathComponent(fileName)
}

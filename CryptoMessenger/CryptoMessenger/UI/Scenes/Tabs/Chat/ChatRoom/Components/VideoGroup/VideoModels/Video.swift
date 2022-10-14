import Foundation

struct Video: Decodable, Identifiable {
  let id = UUID()
  let title: String
  let fileName: String
  let subtitle: String
  let remoteVideoURL: URL?

  private enum CodingKeys: String, CodingKey {
    case title, subtitle
    case fileName = "file_name"
    case remoteVideoURL = "remote_video_url"
  }
}

extension Video {
  var localVideoURL: URL? {
    return Bundle.main.url(forResource: fileName, withExtension: "mp4")
  }

  var videoURL: URL? {
    return remoteVideoURL ?? localVideoURL
  }
}

extension Video {

  static func fetchRemoteVideos() -> [Video] {
    return readJSON(fileName: "RemoteVideos")
  }
}

func readJSON<T: Decodable>(fileName: String) -> [T] {
  if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
    do {
      let data = try Data(contentsOf: url)
      return try JSONDecoder().decode([T].self, from: data)
    } catch {
      print("Failed decoding JSON file: \(fileName).")
      return []
    }
  }
  return []
}

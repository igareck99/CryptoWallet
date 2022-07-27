import Foundation

func getCreationDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}

func intToDate(_ duration: Int) -> String {
    let formattedDuration = Int(duration / 1000)
    if duration == 0 {
        return ""
    } else {
        if formattedDuration < 60 {
            return formattedDuration > 9 ? String("00:\(formattedDuration)") : String("00:0\(formattedDuration)")
        }
        if formattedDuration > 61 {
            return String("0\(Int(formattedDuration / 60)):\(formattedDuration % 60)")
        }
        return String(formattedDuration)
    }
}

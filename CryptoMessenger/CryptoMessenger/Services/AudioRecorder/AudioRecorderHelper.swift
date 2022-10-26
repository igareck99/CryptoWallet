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
        if formattedDuration % 60 < 9 {
            return String("0\(Int(formattedDuration / 60)):0\(formattedDuration % 60)")
        } else {
            return String("0\(Int(formattedDuration / 60)):\(formattedDuration % 60)")
        }
    }
}

func anotherIntToDate(_ duration: Int) -> String {
    if duration == 0 {
        return ""
    } else {
        if duration < 60 {
            return duration > 9 ? String("0:\(duration)") : String("0:0\(duration)")
        }
        if duration % 60 < 9 {
            return String("0\(Int(duration / 60)):0\(duration % 60)")
        } else {
            return String("0\(Int(duration / 60)):\(duration % 60)")
        }
    }
}

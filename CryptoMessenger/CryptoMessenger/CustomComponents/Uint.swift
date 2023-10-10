import Foundation

// MARK: - Units

struct Units {
  
  public let bytes: Int64
  
  public var kilobytes: Double {
    return Double(bytes) / 1_024
  }
  
  public var megabytes: Double {
    return kilobytes / 1_024
  }
  
  public var gigabytes: Double {
    return megabytes / 1_024
  }
  
  public init(bytes: Int64) {
    self.bytes = bytes
  }
  
  public func getReadableUnit() -> String {
    switch bytes {
    case 0..<1_024:
      return "\(bytes) B"
    case 1_024..<(1_024 * 1_024):
      return "\(String(format: "%.1f", kilobytes)) Kb"
    case 1_024..<(1_024 * 1_024 * 1_024):
      return "\(String(format: "%.1f", megabytes)) Mb"
    case (1_024 * 1_024 * 1_024)...Int64.max:
      return "\(String(format: "%.1f", gigabytes)) Gb"
    default:
      return "\(bytes) bytes"
    }
  }
}

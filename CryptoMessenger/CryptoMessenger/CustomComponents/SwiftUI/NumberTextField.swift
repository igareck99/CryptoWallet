import SwiftUI

class MyStingyDouble {
    var value: Double
    var string: String {
        didSet {
            if let tmp: Double = Double(string) {
                value = tmp
            }
        }
    }
    var format: String
    var name: String

    init(name: String, value: Double, format: String) {
        self.string = String(format: format, value)
        self.value = value
        self.name = name
        self.format = format
    }

    func set(value: Double) {
        self.value = value
        self.string = String(format: self.format, value)
    }
}

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3
        formatter.numberStyle = .decimal
        return formatter
    }
}

class OO: ObservableObject {
  @Published var myFirstDouble: String = "0"
  var firstDouble: Double {
      get {
          if let tmp: Double = Double(myFirstDouble) {
            return tmp
          }
          return 0
      }

      set(newValue) {
         myFirstDouble = String(format: "%0.4f", firstDouble)
      }
  }
}

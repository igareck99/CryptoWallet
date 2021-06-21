import Foundation

// MARK: NSObject ()

extension NSObject {

    // MARK: - Internal Properties

    class var className: String {
        let fullName = NSStringFromClass(self)
        if let result = fullName.components(separatedBy: ".").last {
            return result
        }

        return fullName
    }

    var className: String { type(of: self).className }
}

func className(of object: AnyObject) -> String {
    String(describing: object).components(separatedBy: ".").last ?? String(describing: object)
}

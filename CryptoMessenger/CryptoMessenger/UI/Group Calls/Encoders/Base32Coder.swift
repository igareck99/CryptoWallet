// swiftlint: disable: all
import Foundation

final class Base32Coder {

	static func encodedString(_ string: String, padding: Bool = true) -> String {
		let encodedString = string.base32EncodedString
		return padding ? encodedString : encodedString.replacingOccurrences(of: "=", with: "")
	}
}

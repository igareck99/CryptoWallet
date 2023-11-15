import Foundation

// MARK: - String ()

extension String {

    // MARK: - Internal Properties

    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
    var firstLetter: String { first.map(String.init) ?? "" }
    var numbers: String { filter { "0"..."9" ~= $0 } }

    // MARK: - Internal Methods

    subscript(i: Int) -> String { self[i ..< i + 1] }

    func substring(fromIndex: Int) -> String { self[min(fromIndex, count) ..< count] }

    func substring(toIndex: Int) -> String { self[0 ..< max(0, toIndex)] }

    subscript(r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func replaceCharacters(characters: String, toSeparator: String) -> String {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = components(separatedBy: characterSet)
        let result = components.joined(separator: toSeparator)
        return result
    }
    
    func wipeCharacters(characters: String) -> String {
        return self.replaceCharacters(characters: characters, toSeparator: "")
    }
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }

    func width(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

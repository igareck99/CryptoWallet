//
//  RandomColor.swift
//  Greetty
//
//  Created by Dmitrii Ziablikov on 24.05.2021.
//

#if canImport(UIKit)

import UIKit
extension UIColor {
    class var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 0.7
        )
    }
}

#elseif canImport(SwiftUI)
import SwiftUI

extension Color {
    class var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
#endif

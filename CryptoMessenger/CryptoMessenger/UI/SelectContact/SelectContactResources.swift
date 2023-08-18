import SwiftUI
import Foundation


protocol SelectContactResourcable {
    static var titleColor: Color { get }
    
    static var textColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var background: Color { get }
    
    static var textBoxBackground: Color { get }
}

enum SelectContactResources: SelectContactResourcable {
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var background: Color {
        .white 
    }
    
    static var textBoxBackground: Color {
        .aliceBlue
    }
}

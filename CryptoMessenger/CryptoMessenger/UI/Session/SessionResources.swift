import SwiftUI
import Foundation

protocol SessionResourcable {
    static var sessionDescription: String { get }
    
    static var sessionFinishOne: String { get }
    
    static var sessionFinishAll: String { get }
    
    static var background: Color { get }
    
    static var title: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var backggroundFodding: Color { get }
}

enum SessionResources: SessionResourcable{
    
    static var sessionDescription: String {
        R.string.localizable.sessionDescription()
    }
    
    static var sessionFinishAll: String {
        R.string.localizable.sessionFinishAll()
    }
    
    static var sessionFinishOne: String {
        R.string.localizable.sessionFinishOne()
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var backggroundFodding: Color {
        .chineseBlack04
    }
    
    static var background: Color {
        .white
    }
    
    static var title: Color {
        .chineseBlack
    }
}

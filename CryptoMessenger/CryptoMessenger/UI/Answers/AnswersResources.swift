import SwiftUI
import Foundation


protocol AnswersResourcable {
    static var additionalMenuQuestions: String { get }
    
    static var background: Color { get }
    
    static var textBoxBackground: Color { get }
}


enum AnswersResources: AnswersResourcable{
    static var additionalMenuQuestions: String {
        R.string.localizable.additionalMenuQuestions()
    }
    static var background: Color {
        .white 
    }
    
    static var textBoxBackground: Color {
        .aliceBlue
    }
}

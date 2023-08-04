import SwiftUI
import Foundation


protocol SelectChannelTypeResourcable{
    
    static var backButtonImage: Image { get }
    
    
    static var titleColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var background: Color { get }
}


enum SelectChannelTypeResources: SelectChannelTypeResourcable{
    static var backButtonImage: Image {
        R.image.navigation.backButton.image
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var background: Color {
        .white
    }
}

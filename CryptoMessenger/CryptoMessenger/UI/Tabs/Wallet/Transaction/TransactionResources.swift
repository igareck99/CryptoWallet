import SwiftUI
import Foundation

protocol TransactionResourcable {
    static var transactionTitleAll: String { get }
    
    static var backgroundFodding: Color { get }
    
    static var textColor: Color { get }
    
    static var background: Color { get }
    
}

enum TransactionResources: TransactionResourcable{
    static var transactionTitleAll: String {
        R.string.localizable.transactionTitleAll()
    }
    
    static var backgroundFodding: Color {
        .chineseBlack04
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var background: Color {
        .white
    }
}

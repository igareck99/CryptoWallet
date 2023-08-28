import SwiftUI

// MARK: - SelectViewModelDelegate

protocol SelectContactViewModelDelegate: ObservableObject {

    func send(_ event: SelectContactFlow.Event)

    var usersViews: [any ViewGeneratable] { get }

    var contactsLimit: Int? { get }
    
    var resources: SelectContactResourcable.Type { get }
    
    var isButtonAvailable: Bool { get }
    
    func onFinish()
    
    func getButtonColor() -> Color
}

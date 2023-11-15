import SwiftUI

// MARK: - SelectContactViewModelDelegate

protocol SelectContactViewModelDelegate: ObservableObject {

    func send(_ event: SelectContactFlow.Event)
    
    var searchText: String { get set }
    
    var usersViews: [any ViewGeneratable] { get }

    var contactsLimit: Int? { get }
    
    var text: String { get set }
    
    var usersForCreate: [any ViewGeneratable] { get set }
    
    var resources: SelectContactResourcable.Type { get }
    
    var isButtonAvailable: Bool { get }
    
    func onFinish()
    
    func getButtonColor() -> Color
    
    var mode: ContactViewMode { get }
    
    func dismissSheet()
}

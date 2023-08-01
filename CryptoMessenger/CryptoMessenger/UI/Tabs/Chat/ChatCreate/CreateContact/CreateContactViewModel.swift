import SwiftUI

// MARK: - CreateContactViewModel

final class CreateContactViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Injectable var contactsStore: ContactsManager
    var coordinator: ChatCreateFlowCoordinatorProtocol?
    let resources: CreateContactResourcable.Type
    
    init(
        resources: CreateContactResourcable.Type = CreateContactResources.self
    ) {
        self.resources = resources
    }
    
    
    func popToRoot() {
        coordinator?.toParentCoordinator()
    }
}

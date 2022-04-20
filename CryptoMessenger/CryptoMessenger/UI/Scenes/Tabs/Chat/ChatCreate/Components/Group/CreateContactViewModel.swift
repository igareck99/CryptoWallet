import SwiftUI

// MARK: - CreateContactViewModel

final class CreateContactViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Injectable var contactsStore: ContactsManager

}

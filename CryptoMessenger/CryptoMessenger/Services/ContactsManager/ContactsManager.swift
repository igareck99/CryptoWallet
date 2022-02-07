import Contacts
import ContactsUI

// MARK: - ContactInfo

struct ContactInfo: Identifiable {

    // MARK: - Internal Properties

    let id = UUID().uuidString
    let firstName: String
    let lastName: String
    let phoneNumber: String
    var imageData: Data?
}

// MARK: - ContactsStore

protocol ContactsStore {
    func fetch(completionHandler: @escaping GenericBlock<([ContactInfo], Error?)>)
}

// MARK: - ContactsManager

final class ContactsManager: ContactsStore {

    // MARK: - Private Properties

    private let contactStore = CNContactStore()
    private let keysToFetch = [
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataKey
    ] as [CNKeyDescriptor]

    // MARK: - Internal Methods

    func fetch(completionHandler: @escaping GenericBlock<([ContactInfo], Error?)>) {
        checkAuthorization { isAuthorized in
            guard isAuthorized else {
                completionHandler(([], nil))
                return
            }

            do {
                let contacts = try self.fetchContacts()
                completionHandler((contacts, nil))
            } catch {
                completionHandler(([], error))
            }
        }
    }

    // MARK: - Private Methods

    private func checkAuthorization(completionHandler: @escaping GenericBlock<Bool>) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            contactStore.requestAccess(for: .contacts) { isAuthorized, _ in
                completionHandler(isAuthorized)
            }
        default:
            completionHandler(false)
        }
    }

    private func fetchContacts() throws -> [ContactInfo] {
        var contacts: [ContactInfo] = []
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        do {
            try contactStore.enumerateContacts(with: request) { info, _ in
                var contact = ContactInfo(
                    firstName: info.givenName,
                    lastName: info.familyName,
                    phoneNumber: info.phoneNumbers.first?.value.stringValue ?? ""
                )
                if info.imageData != nil, let imageData = info.imageData {
                    contact.imageData = imageData
                }
                contacts.append(contact)
            }
        }

        return contacts
    }
}

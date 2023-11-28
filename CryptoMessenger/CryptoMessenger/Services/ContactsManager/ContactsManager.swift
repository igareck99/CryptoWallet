import Contacts
import UIKit

typealias ContactRequestResult = Result<[ContactInfo], ContactsManager.RequestError>
typealias ContactsRequestCompletion = (ContactRequestResult) -> Void

protocol ContactsStore {

	func reuqestContactsAccessState() -> AccessState

	func requestContactsAccess(completion: @escaping (Bool) -> Void)

	func fetchContacts(completion: @escaping ContactsRequestCompletion)

	func fetch(completion: @escaping GenericBlock<([ContactInfo], Error?)>)

	func createContact(
		selectedImage: UIImage?,
		nameSurnameText: String,
		numberText: String
	)
}

enum AccessState {
    case allowed
    case denied
    case notDetermined
    case restricted
    case unknown
}

// MARK: - ContactsManager

final class ContactsManager {

	enum RequestError: Error {
		case requestFailed
	}

    // MARK: - Private Properties

    private let contactStore = CNContactStore()
    private let keysToFetch = [
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataKey
    ] as [CNKeyDescriptor]

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
                if let imageData = info.imageData {
                    contact.imageData = imageData
                }
                contacts.append(contact)
            }
        }
        return contacts
    }
}

// MARK: - ContactsStore

extension ContactsManager: ContactsStore {

	func fetchContacts(completion: @escaping ContactsRequestCompletion) {
        Task {
            guard let contacts = try? await requestContacts() else {
                await MainActor.run {
                    completion(.failure(.requestFailed))
                }
                return
            }
            await MainActor.run {
                completion(.success(contacts))
            }
        }
	}

    private func requestContacts() async throws -> [ContactInfo] {
        var contacts: [ContactInfo] = []
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
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
        return contacts
    }

    func fetch(completion: @escaping GenericBlock<([ContactInfo], Error?)>) {
        checkAuthorization { [weak self] isAuthorized in
            guard isAuthorized, let contacts = try? self?.fetchContacts()
			else {
				completion(([], nil))
                return
            }

			completion((contacts, nil))
        }
    }

	func createContact(
		selectedImage: UIImage?,
		nameSurnameText: String,
		numberText: String
	) {
		let contact = CNMutableContact()
		if selectedImage != nil {
			contact.imageData = selectedImage?.jpegData(compressionQuality: 1.0)
		}
		contact.givenName = nameSurnameText
		contact.phoneNumbers = [CNLabeledValue(
			label: CNLabelPhoneNumberiPhone,
			value: CNPhoneNumber(stringValue: numberText))]
		let store = CNContactStore()
		let saveRequest = CNSaveRequest()
		saveRequest.add(contact, toContainerWithIdentifier: nil)
		try? store.execute(saveRequest)
	}

	func reuqestContactsAccessState() -> AccessState {
		let contactsAuthStatus: CNAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
		let accessStatuses: [CNAuthorizationStatus: AccessState] = [
			.authorized: .allowed,
			.notDetermined: .notDetermined,
			.denied: .denied,
			.restricted: .restricted
		]
		return  accessStatuses[contactsAuthStatus] ?? .unknown
	}

	func requestContactsAccess(completion: @escaping (Bool) -> Void) {
		contactStore.requestAccess(for: .contacts) { isAccessGranted, _ in
			completion(isAccessGranted)
		}
	}
}

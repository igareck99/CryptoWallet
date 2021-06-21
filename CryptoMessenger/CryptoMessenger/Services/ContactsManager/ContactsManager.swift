import Contacts
import ContactsUI

// MARK: ContactManagerInterface

protocol ContactManagerInterface {
    func fetchAll(completionHandler: @escaping (([PhoneContact], Error?) -> Void))
}

final class ContactManager: ContactManagerInterface {

    // MARK: - Private Properties

    private let contactStore = CNContactStore()
    private let keysToFetch = [
        CNContactGivenNameKey,
        CNContactDatesKey,
        CNContactTypeKey,
        CNContactPhoneNumbersKey,
        CNContactMiddleNameKey,
        CNContactFamilyNameKey,
        CNContactImageDataKey
    ] as [CNKeyDescriptor]

    // MARK: - Internal Methods

    func fetchAll(completionHandler: @escaping (([PhoneContact], Error?) -> Void)) {
        var phoneContacts: [PhoneContact] = []

        checkAuthorization { isAuthorized in
            if isAuthorized {
                let contacts = self.getContacts()
                for contact in contacts {
                    if let phoneContact = self.createPhoneContact(contact) {
                        phoneContacts.append(phoneContact)
                    } else {
                        continue
                    }
                }
                completionHandler(phoneContacts, nil)
            } else {
                completionHandler(phoneContacts, nil)
            }
        }
    }

    // MARK: - Private Methods

    private func createPhoneContact(_ contact: CNContact) -> PhoneContact? {
        for phoneNumber in contact.phoneNumbers {
            if let label = phoneNumber.label {
                let number = phoneNumber.value
                let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                return PhoneContact(
                    identifier: contact.identifier,
                    givenName: contact.givenName,
                    familyName: contact.familyName,
                    image: contact.imageData,
                    phoneNumber: number.stringValue,
                    numberLabel: localizedLabel
                )
            }
        }

        return nil
    }

    private func checkAuthorization(completionHandler: @escaping (( _ isAuthorized: Bool) -> Void)) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)

        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            contactStore.requestAccess(for: .contacts) { isAuthorized, _ in
                completionHandler(isAuthorized)
            }
        case .denied:
            completionHandler(false)
        case .restricted:
            completionHandler(false)
        default:
            completionHandler(false)
        }
    }

    private func getContacts() -> [CNContact] {
        var results: [CNContact] = []
        var allContainers: [CNContainer] = []

        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            return results
        }

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(
                    matching: fetchPredicate,
                    keysToFetch: self.keysToFetch
                )
                results.append(contentsOf: containerResults)
            } catch {
                return results
            }
        }

        return results
    }
}

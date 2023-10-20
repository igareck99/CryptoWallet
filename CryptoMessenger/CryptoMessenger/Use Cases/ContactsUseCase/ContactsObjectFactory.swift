import Foundation
import MatrixSDK

// MARK: - ContactsObjectFactoryProtocol

protocol ContactsObjectFactoryProtocol {
    
    func makeLastUsersContacts(contacts: [ContactInfo],
                               matrixUseCase: MatrixUseCaseProtocol,
                               config: ConfigType,
                               data: [String: String],
                               onTap: @escaping (Contact) -> Void) -> [Contact]
    
    func makeExisitingContacts(contacts: [ContactInfo],
                               config: ConfigType,
                               lastUsers: [Contact],
                               data: [String: String],
                               onTap: @escaping (Contact) -> Void) -> [Contact]
    func makeWaitingContacts(contacts: [ContactInfo],
                             lastUsers: [Contact],
                             data: [String: String],
                             onTap: @escaping (Contact) -> Void) -> [Contact]
}

struct ContactsObjectFactory {}

// MARK: - ContactsObjectFactory(ContactsObjectFactoryProtocol)

extension ContactsObjectFactory: ContactsObjectFactoryProtocol {
    
    func makeLastUsersContacts(contacts: [ContactInfo],
                               matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
                               config: ConfigType = Configuration.shared,
                               data: [String: String],
                               onTap: @escaping (Contact) -> Void) -> [Contact] {
        let sorted = contacts.sorted(by: { $0.firstName < $1.firstName })
        let mxUsers: [MXUser] = matrixUseCase.allUsers()
        let users: [Contact] = mxUsers
            .filter { $0.userId != matrixUseCase.getUserId() }
            .map {
                var contact = Contact(
                    mxId: $0.userId ?? "",
                    avatar: nil,
                    name: $0.displayname ?? $0.userId ?? "",
                    status: $0.statusMsg ?? "Привет, теперь я в Aura",
                    phone: "",
                    type: .lastUsers, onTap: { value in
                        onTap(value)
                    }
                )
                let homeServer = config.matrixURL
                if let avatar = $0.avatarUrl {
                    contact.avatar = MXURL(mxContentURI: avatar)?.contentURL(on: homeServer)
                }
                return contact
            }
        return users
    }

    func makeExisitingContacts(contacts: [ContactInfo],
                               config: ConfigType,
                               lastUsers: [Contact],
                               data: [String: String],
                               onTap: @escaping (Contact) -> Void) -> [Contact] {
        let sorted = contacts.sorted(by: { $0.firstName < $1.firstName })
        let existing: [Contact] = sorted
            .filter { data.keys.contains($0.phoneNumber.numbers) }
            .map {
                .init(
                    mxId: data[$0.phoneNumber] ?? "",
                    avatar: nil,
                    name: $0.firstName + " " + $0.lastName,
                    status: "Привет, теперь я в Aura",
                    phone: $0.phoneNumber,
                    type: .existing, onTap: { value in
                        onTap(value)
                    }
                )
            }
            .filter { contact in
                !lastUsers.contains(where: { $0.mxId == contact.mxId })
            }
        return existing
    }
    
    func makeWaitingContacts(contacts: [ContactInfo],
                             lastUsers: [Contact],
                             data: [String: String],
                             onTap: @escaping (Contact) -> Void) -> [Contact] {
        let sorted = contacts.sorted(by: { $0.firstName < $1.firstName })
        let waitingContacts: [Contact] = sorted.filter { !data.keys.contains($0.phoneNumber.numbers) }.map {
            .init(
                mxId: data[$0.phoneNumber] ?? "",
                avatar: nil,
                name: $0.firstName + " " + $0.lastName,
                status: "",
                phone: $0.phoneNumber,
                type: .waitingContacts, onTap: { value in
                    onTap(value)
                }
            )
        }
        return waitingContacts
    }
}

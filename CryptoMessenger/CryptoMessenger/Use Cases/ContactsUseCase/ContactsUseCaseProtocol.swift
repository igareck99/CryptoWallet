import Foundation

// MARK: - ContactsUseCaseProtocol

protocol ContactsUseCaseProtocol {

    func getContacts() -> [Contact]
    func reuqestUserContacts(completion: @escaping ([ContactInfo]) -> Void)
    func requestContactsAccess(completion: @escaping (Bool) -> Void)
    func syncContacts(completion: @escaping (AccessState) -> Void)
    func matchServerContacts(_ contacts: [ContactInfo],
                             _ mode: ContactViewMode,
                             completion: @escaping ([Contact]) -> Void,
                             onTap: @escaping (Contact) -> Void)
    func getCountryAndCode(_ number: String) -> (String, String)
}

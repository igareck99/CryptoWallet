import Foundation

enum KeychainServiceAssembly {
    static func build() -> KeychainServiceProtocol {
        let config: ConfigType = Configuration.shared
        let serviceNameId = config.keychainServiceName
        let accessGroup = config.keychainAccessGroup
        let wrapper = KeychainWrapper(
            serviceNameId: serviceNameId,
            accessGroup: accessGroup
        ) {
            UserDefaultsService.shared.userId ?? ""
        }
        let service = KeychainService(wrapper: wrapper)
        return service
    }
}

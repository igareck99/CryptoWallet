import Foundation

enum KeychainServiceAssembly {
    static func build() -> KeychainServiceProtocol {
        let config: ConfigType = Configuration.shared
        let serviceName = config.keychainServiceName
        let accessGroup = config.keychainAccessGroup
        let wrapper = KeychainWrapper(
            serviceName: serviceName,
            accessGroup: accessGroup
        )
        let service = KeychainService(wrapper: wrapper)
        return service
    }
}

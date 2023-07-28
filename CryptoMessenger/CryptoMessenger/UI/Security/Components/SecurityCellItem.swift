import Foundation

// MARK: - SecurityCellItem

enum SecurityCellItem: CaseIterable, Identifiable {

    // MARK: - Types

    case profileObserve, seedPhrase, session, blockList,
         lastSeen, calls, geoposition, telephone 

    // MARK: - Internal Properties

    var id: UUID { UUID() }
    var result: (title: String, state: String) {
        switch self {
        case .profileObserve:
            return (R.string.localizable.securityProfileObserve(),
                    R.string.localizable.securityProfileObserveState())
        case .lastSeen:
            return (R.string.localizable.securityLastSeen(),
                    R.string.localizable.securityLastSeen())
        case .calls:
            return (R.string.localizable.securityCallsTitle(),
                    R.string.localizable.securityContactsAll())
        case .geoposition:
            return (R.string.localizable.securityGeoposition(),
                    R.string.localizable.securityContactsAll())
        case .telephone:
            return (R.string.localizable.securityTelephone(),
                    R.string.localizable.securityContactsAll())
        case .session:
            return (R.string.localizable.securitySessionTitle(),
                    "Показываются все сеансы с устройств")
        case .blockList:
            return (R.string.localizable.securityBlackListTitle(),
                    "")
        case .seedPhrase:
            return (R.string.localizable.walletManagerSecretPhrase(),
            "Теперь ваши сообщения шифруются и доступен кошелек")
        }
    }}

import Foundation

protocol ProfileSettingsMenuProtocol: ObservableObject {
    var isPhraseAvailable: Bool { get }

    func viewHeight() -> CGFloat
    func settingsTypes() -> [ProfileSettingsMenu]
    func onTapItem(type: ProfileSettingsMenu)
}

// MARK: - ProfileSettingsMenuViewModel

final class ProfileSettingsMenuViewModel {
    var isPhraseAvailable: Bool
    let remoteConfigUseCase: RemoteConfigFacade
    let onSelect: GenericBlock<ProfileSettingsMenu>

    init(
        remoteConfigUseCase: RemoteConfigFacade = RemoteConfigUseCaseAssembly.useCase,
        onSelect: @escaping GenericBlock<ProfileSettingsMenu>
    ) {
        self.remoteConfigUseCase = remoteConfigUseCase
        self.onSelect = onSelect
        self.isPhraseAvailable = remoteConfigUseCase.isPhraseV1Available
    }
}

// MARK: - ProfileSettingsMenuProtocol

extension ProfileSettingsMenuViewModel: ProfileSettingsMenuProtocol {

    func onTapItem(type: ProfileSettingsMenu) {
        onSelect(type)
    }

    func viewHeight() -> CGFloat {
        CGFloat(settingsTypes().count) * CGFloat(52) + CGFloat(18)
    }

    func settingsTypes() -> [ProfileSettingsMenu] {
        [
            .profile,
            // TODO: ???? почему-то нет перехода в координаторе
            // .personalization,
            .security,
            .notifications,
            .about
        ]
    }
}

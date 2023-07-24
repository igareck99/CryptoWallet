import Foundation

// MARK: - ProfileSettingsMenuViewModel

final class ProfileSettingsMenuViewModel: ObservableObject {

    // MARK: - Internal Properties

    var isPhraseAvailable: Bool

    // MARK: - Private Properties

    let remoteConfigUseCase = RemoteConfigUseCaseAssembly.useCase

    // MARK: - Lifecycle

    init() {
        self.isPhraseAvailable = remoteConfigUseCase.isPhraseV1Available
    }

    // MARK: - Internal Methods

	func settingsTypes() -> [ProfileSettingsMenu] {

		let types = ProfileSettingsMenu.allCases
		return types
	}
}

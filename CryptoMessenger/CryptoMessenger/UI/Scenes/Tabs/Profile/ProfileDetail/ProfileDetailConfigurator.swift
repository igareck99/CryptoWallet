import Foundation
import SwiftUI

// MARK: - ProfileDetailConfigurator

enum ProfileDetailConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: ProfileDetailSceneDelegate?,
                               image: Binding<UIImage?>) -> ProfileDetailView {
		let userSettings = UserDefaultsService.shared
		let keychainService = KeychainService.shared
        let coreDataService = CoreDataService.shared
        let privateDataCleaner = PrivateDataCleaner.shared
		let viewModel = ProfileDetailViewModel(
			userSettings: userSettings,
            keychainService: keychainService,
            coreDataService: coreDataService,
            privateDataCleaner: privateDataCleaner
		)
        viewModel.coordinator = delegate
        let view = ProfileDetailView(viewModel: viewModel, selectedAvatarImage: image)
        return view
    }
}

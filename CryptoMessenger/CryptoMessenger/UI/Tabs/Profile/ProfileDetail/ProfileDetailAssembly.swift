import Foundation
import SwiftUI

// MARK: - ProfileDetailAssembly

enum ProfileDetailAssembly {

    // MARK: - Static Methods
    
    static func build(_ coordinator: ProfileFlowCoordinatorProtocol,
                      _ image: Binding<UIImage?>) -> some View {
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
        viewModel.coordinator = coordinator
        let view = ProfileDetailView(viewModel: viewModel,
                                     selectedAvatarImage: image)
        return view
    }
}

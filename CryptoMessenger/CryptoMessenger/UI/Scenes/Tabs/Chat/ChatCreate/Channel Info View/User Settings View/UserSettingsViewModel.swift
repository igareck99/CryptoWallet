import SwiftUI

protocol UserSettingsViewModelProtocol: ObservableObject {
    
    var items: [any ViewGeneratable] { get }
    
}

final class UserSettingsViewModel {
    
    var items: [any ViewGeneratable] {
        mockItems
    }
    
}

// MARK: - UserSettingsViewModelProtocol

extension UserSettingsViewModel: UserSettingsViewModelProtocol {
    
}

// MARK: - Mocks

private extension UserSettingsViewModel {
    
    var mockItems: [any ViewGeneratable] {
        [
            UserSettingModel(
                title: "Открыть профиль",
                titleColor: .woodSmokeApprox,
                imageName: "person.crop.circle",
                imageColor: .azureRadianceApprox,
                accessoryImageName: "chevron.right",
                accessoryImageColor: .ironApprox
            ) {
                debugPrint("onTap Open profile")
            },
            UserSettingModel(
                title: "Изменить роль",
                titleColor: .woodSmokeApprox,
                imageName: "highlighter",
                imageColor: .azureRadianceApprox
            ) {
                debugPrint("onTap Change role")
            },
            UserSettingModel(
                title: "Удалить из канала",
                titleColor: .amaranthApprox,
                imageName: "trash",
                imageColor: .amaranthApprox
            ) {
                debugPrint("onTap Remove from channel")
            }
        ]
    }
}

import Foundation

protocol UserSettingsFactoryProtocol {
    static func makeItems(
        viewModel: any UserSettingsViewModelProtocol
    ) -> [any ViewGeneratable]
}

enum UserSettingsFactory: UserSettingsFactoryProtocol {
    static func makeItems(
        viewModel: any UserSettingsViewModelProtocol
    ) -> [any ViewGeneratable] {
        [
            UserSettingModel(
                title: R.string.localizable.channelSettingsOpenProfile(),
                titleColor: .woodSmokeApprox,
                imageName: "person.crop.circle",
                imageColor: .azureRadianceApprox,
                accessoryImageName: "chevron.right",
                accessoryImageColor: .ironApprox
            ) {
                debugPrint("onTap Open profile")
                viewModel.onTapShowProfile()
            },
            
            UserSettingModel(
                title: R.string.localizable.channelSettingsChangeRole(),
                titleColor: .woodSmokeApprox,
                imageName: "highlighter",
                imageColor: .azureRadianceApprox
            ) {
                debugPrint("onTap Change role")
                viewModel.onTapChangeRole()
            },
            
            UserSettingModel(
                title: R.string.localizable.channelSettingsDeleteFromChannel(),
                titleColor: .amaranthApprox,
                imageName: "trash",
                imageColor: .amaranthApprox
            ) {
                debugPrint("onTap Remove from channel")
                viewModel.onTapRemoveUser()
            }
        ]
    }
}

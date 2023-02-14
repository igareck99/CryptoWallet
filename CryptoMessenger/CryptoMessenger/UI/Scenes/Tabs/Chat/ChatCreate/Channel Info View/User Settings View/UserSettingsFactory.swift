import Foundation

protocol UserSettingsFactoryProtocol {
    static func makeItems(
        _ tappedUserId: Bool,
        viewModel: any UserSettingsViewModelProtocol
    ) -> [any ViewGeneratable]
}

enum UserSettingsFactory: UserSettingsFactoryProtocol {
    static func makeItems(
        _ roleCompare: Bool = true,
        viewModel: any UserSettingsViewModelProtocol
    ) -> [any ViewGeneratable] {
        var views: [any ViewGeneratable] = [UserSettingModel(
            title: R.string.localizable.channelSettingsOpenProfile(),
            titleColor: .woodSmokeApprox,
            imageName: "person.crop.circle",
            imageColor: .azureRadianceApprox,
            accessoryImageName: "chevron.right",
            accessoryImageColor: .ironApprox
        ) {
            debugPrint("onTap Open profile")
            viewModel.onTapShowProfile()
        }]
        if roleCompare {
            views.append(UserSettingModel(
                title: R.string.localizable.channelSettingsChangeRole(),
                titleColor: .woodSmokeApprox,
                imageName: "highlighter",
                imageColor: .azureRadianceApprox
            ) {
                debugPrint("onTap Change role")
                viewModel.onTapChangeRole()
            })
        }
        views.append(UserSettingModel(
            title: R.string.localizable.channelSettingsDeleteFromChannel(),
            titleColor: .amaranthApprox,
            imageName: "trash",
            imageColor: .amaranthApprox
        ) {
            debugPrint("onTap Remove from channel")
            viewModel.onTapRemoveUser()
        })
        return views
    }
}

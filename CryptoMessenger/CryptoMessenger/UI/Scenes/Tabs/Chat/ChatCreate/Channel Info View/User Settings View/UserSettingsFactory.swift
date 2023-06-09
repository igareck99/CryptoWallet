import Foundation

// MARK: - UserSettingsFactoryProtocol

protocol UserSettingsFactoryProtocol {
    static func makeItems(
        _ tappedUserId: ChannelUserActions,
        viewModel: any UserSettingsViewModelProtocol
    ) -> [any ViewGeneratable]
}

// MARK: - UserSettingsFactory(UserSettingsFactoryProtocol)

enum UserSettingsFactory: UserSettingsFactoryProtocol {

    // MARK: - Static Methods

    static func makeItems(
        _ roleCompare: ChannelUserActions,
        viewModel: any UserSettingsViewModelProtocol
    ) -> [any ViewGeneratable] {
        var views: [any ViewGeneratable] = [UserSettingModel(
            title: R.string.localizable.channelSettingsOpenProfile(),
            titleColor: .chineseBlack,
            imageName: "person.crop.circle",
            imageColor: .lapisLazuli,
            accessoryImageName: "chevron.right",
            accessoryImageColor: .water
        ) {
            viewModel.onTapShowProfile()
        }]
        if roleCompare.changeRole {
            views.append(UserSettingModel(
                title: R.string.localizable.channelSettingsChangeRole(),
                titleColor: .chineseBlack,
                imageName: "highlighter",
                imageColor: .lapisLazuli
            ) {
                viewModel.onTapChangeRole()
            })
        }
        if roleCompare.delete {
            views.append(UserSettingModel(
                title: R.string.localizable.channelSettingsDeleteFromChannel(),
                titleColor: .spanishCrimson,
                imageName: "trash",
                imageColor: .spanishCrimson
            ) {
                viewModel.onTapRemoveUser()
            })
        }
        return views
    }
}

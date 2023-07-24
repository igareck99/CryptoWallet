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
            titleColor: .woodSmokeApprox,
            imageName: "person.crop.circle",
            imageColor: .azureRadianceApprox,
            accessoryImageName: "chevron.right",
            accessoryImageColor: .gainsboro
        ) {
            viewModel.onTapShowProfile()
        }]
        if roleCompare.changeRole {
            views.append(UserSettingModel(
                title: R.string.localizable.channelSettingsChangeRole(),
                titleColor: .woodSmokeApprox,
                imageName: "highlighter",
                imageColor: .dodgerTransBlue
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
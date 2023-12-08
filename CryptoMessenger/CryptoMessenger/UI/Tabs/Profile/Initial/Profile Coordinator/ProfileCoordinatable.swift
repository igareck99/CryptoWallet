import SwiftUI

protocol ProfileCoordinatable: Coordinator {

    func onSocialList()

    func galleryPickerFullScreen(
        sourceType: UIImagePickerController.SourceType,
        galleryContent: GalleryPickerContent,
        onSelectImage: @escaping (UIImage?) -> Void,
        onSelectVideo: @escaping (URL?) -> Void
    )

    func imageEditor(
        isShowing: Binding<Bool>,
        image: Binding<UIImage?>,
        viewModel: ProfileViewModel
    )

    func settingsScreens(
        type: ProfileSettingsMenu,
        cooordinator: ProfileCoordinatable,
        image: Binding<UIImage?>
    )

    func pinCode(pinCodeScreen: PinCodeScreenType)

    func sessions()

    func onLogout()

    func showSettings(
        result: @escaping GenericBlock<ProfileSettingsMenu>
    )

    func showFeedPicker(
        sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>
    )

    func blockList()

    func showPhrase(seed: String)

    func generatePhrase()
}

import Foundation
import SwiftUI

protocol ProfileRouterable {
    
    func routePath() -> Binding<NavigationPath>
    
    func presentedItem() -> Binding<BaseSheetLink?>
    
    func socialList()
    
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
    
    func profileDetail(
        coordinator: ProfileCoordinatable,
        image: Binding<UIImage?>
    )
    
    func security(coordinator: ProfileCoordinatable)
    
    func notifications(coordinator: ProfileCoordinatable)
    
    func aboutApp(coordinator: ProfileCoordinatable)
    
    func pinCode(pinCodeScreen: PinCodeScreenType)
    
    func sessions(coordinator: ProfileCoordinatable)
    
    func showSettings(result: @escaping GenericBlock<ProfileSettingsMenu>)
    
    func sheetPicker(
        sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>
    )
    
    func blockList()
    
    func removePresentedItem()
    
    func clearPath()
    
    func showPhrase(
        seed: String,
        type: WatchKeyViewType,
        coordinator: WatchKeyViewModelDelegate
    )
}

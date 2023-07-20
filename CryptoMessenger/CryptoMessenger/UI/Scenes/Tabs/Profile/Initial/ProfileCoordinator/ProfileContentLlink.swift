import SwiftUI

// MARK: - ProfileContentLlink

enum ProfileContentLlink: Hashable, Identifiable {

    case socialList
    case galleryPicker(sourceType: UIImagePickerController.SourceType,
                       galleryContent: GalleryPickerContent,
                       onSelectImage: (UIImage?) -> Void,
                       onSelectVideo: (URL?) -> Void)
    case imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel)
    case profileDetail(_ coordinator: ProfileFlowCoordinatorProtocol,
                       _ image: Binding<UIImage?>)
    case security(_ coordinator: ProfileFlowCoordinatorProtocol)
    case notifications(_ coordinator: ProfileFlowCoordinatorProtocol)
    case questions(_ coordinator: ProfileFlowCoordinatorProtocol)
    case aboutApp(_ coordinator: ProfileFlowCoordinatorProtocol)
    case pinCode(PinCodeScreenType)
    case sessions(_ coordinator: ProfileFlowCoordinatorProtocol)

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ProfileContentLlink, rhs: ProfileContentLlink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - ProfileContentLlink

enum ProfileSheetLlink: Hashable, Identifiable {

    var id: String {
        String(describing: self)
    }

    static func == (lhs: ProfileSheetLlink, rhs: ProfileSheetLlink) -> Bool {
        return rhs.id == lhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

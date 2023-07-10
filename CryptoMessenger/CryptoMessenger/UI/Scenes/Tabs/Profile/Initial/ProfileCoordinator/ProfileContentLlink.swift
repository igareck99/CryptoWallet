import SwiftUI

// MARK: - ProfileContentLlink

enum ProfileContentLlink: Hashable, Identifiable {

    case socialList
    case galleryPicker(selectedImage: Binding<UIImage?>,
                       selectedVideo: Binding<URL?>,
                       sourceType: UIImagePickerController.SourceType,
                       galleryContent: GalleryPickerContent)
    case imageEditor(isShowing: Binding<Bool>,
                     image: Binding<UIImage?>,
                     viewModel: ProfileViewModel)

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
    
    case settings(balance: String)

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

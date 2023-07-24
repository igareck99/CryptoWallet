import SwiftUI

// MARK: - SelectFeedImageType

enum SelectFeedImageType: CaseIterable {
    case camera
    case gallery
    
    var image: Image {
        switch self {
        case .camera:
            return R.image.profile.makePhoto.image
        case .gallery:
            return R.image.profile.selectPhoto.image
        }
    }
    
    var text: String {
        switch self {
        case .camera:
            return "Сделать снимок"
        case .gallery:
            return "Выбрать фото"
        }
    }
    
    var systemType: UIImagePickerController.SourceType {
        switch self {
        case .camera:
            return .camera
        case .gallery:
            return .photoLibrary
        }
    }
}

import Foundation

// MARK: - GalleryPickerContent

enum GalleryPickerContent {
    case photos
    case all
}

// MARK: - GalleryContentType

enum GalleryContentType: String {
    case image = "public.image"
    case video = "public.movie"
    
    static func getTypes(_ type: GalleryPickerContent) -> [String] {
        switch type {
        case .photos:
            return [GalleryContentType.image.rawValue]
        case .all:
            return [GalleryContentType.image.rawValue, GalleryContentType.video.rawValue]
        }
    }
}

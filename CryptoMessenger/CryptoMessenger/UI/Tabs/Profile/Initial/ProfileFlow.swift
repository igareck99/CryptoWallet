import Foundation
import UIKit
import SwiftUI

// MARK: - ProfileFlow

enum ProfileFlow {

    // MARK: - ViewState

    enum ViewState {

        // MARK: - Types

        case idle
        case loading
        case error(message: String)
    }

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case onAppear
        case onProfileAppear
        case onSettings(Binding<UIImage?>)
        case onAddPhoto(UIImage)
        case onSocial
        case onGallery(UIImagePickerController.SourceType)
        case onImageEditor(
            isShowing: Binding<Bool>,
            image: Binding<UIImage?>
        )
        case onFeedImageAdd
    }
}

import SwiftUI

// MARK: - ProfileFeedImageAssembly

enum ProfileFeedImageAssembly {

    // MARK: - Static Methods

    static func build(_ sourceType: @escaping (UIImagePickerController.SourceType) -> Void)
    -> some View {
        let view = SelectFeedImageView { type in
            sourceType(type)
        }
        return view
    }
}

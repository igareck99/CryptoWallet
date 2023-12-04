import SwiftUI

enum ProfileFeedImageAssembly {
    static func build(
        sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>
    ) -> some View {
        let view = SelectFeedImageView { type in
            sourceType(type)
        }
        return view
    }
}

import SwiftUI

enum ProfileFeedImageAssembly {
    static func build(
        sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>
    ) -> some View {
        let viewModel = SelectFeedImageViewModel(sourceType: sourceType)
        let view = SelectFeedImageView(viewModel: viewModel)
        return view
    }
}

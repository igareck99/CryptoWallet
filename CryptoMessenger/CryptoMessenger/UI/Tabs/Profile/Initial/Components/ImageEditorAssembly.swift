import SwiftUI

enum ImageEditorAssembly {
    static func build(
        isShowing: Binding<Bool>,
        image: Binding<UIImage?>,
        viewModel: ProfileViewModel
    ) -> some View {
        let view = ImageEditor(
            theimage: image,
            isShowing: isShowing,
            viewModel: viewModel
        )
        // TODO: Выпилить это отсюда
            .toolbar(.hidden,
                     for: .tabBar)
            .toolbar(.hidden,
                     for: .navigationBar)
            .ignoresSafeArea()
        return view
    }
}

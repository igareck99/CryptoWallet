import SwiftUI

// MARK: - ImageEditorAssembly

enum ImageEditorAssembly {

    // MARK: - Static Methods

    static func build(isShowing: Binding<Bool>,
                      image: Binding<UIImage?>,
                      viewModel: ProfileViewModel) -> some View {
        let view = ImageEditor(theimage: image,
                               isShowing: isShowing,
                               viewModel: viewModel)
            .toolbar(.hidden,
                     for: .tabBar)
            .toolbar(.hidden,
                     for: .navigationBar)
            .ignoresSafeArea()
        return view
    }
}

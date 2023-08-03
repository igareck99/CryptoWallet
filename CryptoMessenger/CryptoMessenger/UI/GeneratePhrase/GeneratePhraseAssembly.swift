import SwiftUI

enum GeneratePhraseAssembly {
    static func build() -> some View {
        let viewModel = GeneratePhraseViewModel()
        let view = GeneratePhraseView(
            viewModel: viewModel
        ) { type in
            switch type {
            case .importKey:
                debugPrint("")
                viewModel.onImport()
            default:
                break
            }
            } onCreate: {
                viewModel.send(.onAppear)
            }
        return view
    }
}

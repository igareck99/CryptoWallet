import SwiftUI

enum GeneratePhraseViewAssembly {
    static func build(
        onSelect: @escaping GenericBlock<GeneratePhraseState>,
        onCreate: @escaping VoidBlock
    ) -> some View {
        let viewModel = GeneratePhraseViewModel()
        let view = GeneratePhraseView(
            viewModel: viewModel,
            onSelect: onSelect,
            onCreate: onCreate
        )
        return view
    }
}

import SwiftUI
import UIKit

// MARK: - CreateContactsAssembly

enum CreateContactsAssembly {

    static func build(_ coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        let viewModel = CreateContactViewModel()
        viewModel.coordinator = coordinator
        let view = CreateContactView(viewModel: viewModel)
        return view
    }
}

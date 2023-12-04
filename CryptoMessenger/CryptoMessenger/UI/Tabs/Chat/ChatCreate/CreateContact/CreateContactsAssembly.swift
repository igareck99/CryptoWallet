import SwiftUI
import UIKit

enum CreateContactsAssembly {
    static func build(coordinator: ChatCreateFlowCoordinatorProtocol) -> some View {
        let viewModel = CreateContactViewModel()
        viewModel.coordinator = coordinator
        let view = CreateContactView(viewModel: viewModel)
        return view
    }
}

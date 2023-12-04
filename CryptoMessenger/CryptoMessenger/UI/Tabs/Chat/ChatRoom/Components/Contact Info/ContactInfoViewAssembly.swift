import SwiftUI

enum ContactInfoViewAssembly {
    static func build(
        data: ChatContactInfo,
        delegate: ContactInfoViewModelDelegate
    ) -> some View {
        let viewModel = ContactInfoViewModel(delegate: delegate)
        return ContactInfoView(viewModel: viewModel, data: data)
    }
}

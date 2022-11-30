import SwiftUI

struct ReactionsGroupView<ViewModel: ReactionsGroupViewModelProtocol>: View {

	@ObservedObject var viewModel: ViewModel

	var body: some View {
		HStack(alignment: .center, spacing: 4) {
			ForEach(viewModel.items, id: \.id ) { item in
				item.view()
			}
		}
	}
}

struct ReactionsGroupTextView<ViewModel: ReactionsGroupViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack(spacing: 4) {
            ForEach(viewModel.items, id: \.id ) { item in
                item.view()
            }
        }
    }
}

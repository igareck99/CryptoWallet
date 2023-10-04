import SwiftUI
import UniformTypeIdentifiers

// MARK: - SocialListView

struct SocialListView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: SocialListViewModel
    @State var editMode: EditMode = .active
    @State var sectionSwitch = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
			Text(viewModel.resources.detailMain)
                .font(.caption1Medium12)
                .foregroundColor(viewModel.resources.textColor)
                .padding(.top, 24)
                .padding(.leading)
			Text(viewModel.resources.detailMessage)
                .font(.caption1Regular12)
                .foregroundColor(viewModel.resources.textColor)
                .padding(.leading)
            List {
                ForEach(viewModel.listData) { item in
					SocialListItemView(item: item, viewModel: viewModel)
						.ignoresSafeArea()
                        .listRowSeparator(.visible)
                        .onDrag {
                            self.viewModel.dragging = item
                            return NSItemProvider(object: NSString())
                        }
                }
                .onMove(perform: { indexSet, value in
                    viewModel.onMove(source: indexSet, destination: value)
                })
                .listRowBackground(viewModel.resources.avatarBackground)
                Spacer().listRowSeparator(.hidden)
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
		}
        .listStyle(.plain)
		.navigationBarHidden(false)
        .toolbar {
            ToolbarItem(placement: .principal) {
				Text(viewModel.resources.detailTitle)
                    .font(.bodySemibold17)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.saveSocialData()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
					Text(viewModel.resources.rightButton)
                        .font(.bodySemibold17)
                        .foregroundColor(viewModel.resources.buttonBackround)
                        .onTapGesture {
                            viewModel.saveSocialData()
                            presentationMode.wrappedValue.dismiss()
                        }
                })
            }
        }
    }
}

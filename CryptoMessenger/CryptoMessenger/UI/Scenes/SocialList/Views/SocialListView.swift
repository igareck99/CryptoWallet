import SwiftUI
import UniformTypeIdentifiers

// MARK: - SocialListView

struct SocialListView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel = SocialListViewModel()
    @State var editMode: EditMode = .active
    @State var sectionSwitch = false
    @Environment(\.presentationMode) private var presentationMode
    @State private var dragging: SocialListItem?

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
			Text(viewModel.resources.detailMain)
                .font(.bold(12))
                .foreground(.darkGray())
                .padding(.top, 24)
                .padding(.leading)
			Text(viewModel.resources.detailMessage)
                .font(.regular(12))
                .foreground(.darkGray())
                .padding(.leading)
            List {
                ForEach(viewModel.listData) { item in
					SocialListItemView(item: item, viewModel: viewModel)
						.ignoresSafeArea()
                        .listRowSeparator(.visible)
                        .onDrag {
                            self.dragging = item
                            return NSItemProvider(object: NSString())
                        }
                }
                .onMove(perform: {_, _  in })
                .listRowBackground(Color(.blue(0.1)))
                Spacer().listRowSeparator(.hidden)
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
		}
		.onDisappear(perform: {
			viewModel.saveSocialData()
		})
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .principal) {
				Text(viewModel.resources.detailTitle)
                    .font(.bold(15))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
					Text(viewModel.resources.rightButton)
                        .font(.bold(15))
                        .foreground(.blue())
                })
            }
        }
    }
}

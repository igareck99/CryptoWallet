import SwiftUI

// MARK: - SocialListItemView

struct SocialListItemView: View {

    // MARK: - Internal Properties

	@State var item: SocialListItem
	@StateObject var viewModel: SocialListViewModel
    @FocusState var focusState: Bool

    // MARK: - Body

	var body: some View {
		HStack(alignment: .center, spacing: 10) {
            HStack {
                item.socialNetworkImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 14)
                TextField(item.text, text: self.$item.url, onEditingChanged: { isEditing in
                    debugPrint("SocialListItemView onEditingChanged: \(self.item.url)")
                    self.viewModel.socialNetworkDidEdited(item: item, isEditing: isEditing)
                })
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                .foregroundColor(Color.chineseBlack)
                .cornerRadius(radius: 8, corners: .allCorners)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .onChange(of: self.item.url, perform: { newValue in
                    debugPrint("SocialListItemView onSubmit: \(self.item.url) \(newValue)")
                    self.viewModel.socialNetworkDidSubmitted(item: item)
                })
                .onSubmit {
                    debugPrint("SocialListItemView onSubmit: \(self.item.url)")
                    self.viewModel.socialNetworkDidSubmitted(item: item)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 67,
                   height: 46)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.aliceBlue)
            )
            .padding(.leading, 16)
			viewModel.resources.dragDropImage.padding(.trailing, 16)
		}
        .background(.clear)
	}
}

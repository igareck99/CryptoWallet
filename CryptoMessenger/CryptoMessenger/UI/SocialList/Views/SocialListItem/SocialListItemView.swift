import SwiftUI

// MARK: - SocialListItemView

struct SocialListItemView: View {

    // MARK: - Internal Properties

	@State var item: SocialListItem
	@StateObject var viewModel: SocialListViewModel
    @FocusState var focusState: Bool

    // MARK: - Body

	var body: some View {
		HStack(alignment: .center, spacing: 40) {
			item.socialNetworkImage
				.resizable()
				.frame(width: 24, height: 24)
				.padding(.leading, 16)
			TextField("", text: self.$item.url, onEditingChanged: { isEditing in
                debugPrint("SocialListItemView onEditingChanged: \(self.item.url)")
				self.viewModel.socialNetworkDidEdited(item: item, isEditing: isEditing)
			})
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
			.frame(height: 30)
			viewModel.resources.dragDropImage.padding(.trailing, 16)
		}
	}
}

import SwiftUI

struct SocialListItemView: View {

	@State var item: SocialListItem
	@StateObject var viewModel: SocialListViewModel

	var body: some View {
		HStack(alignment: .center, spacing: 40) {
			item.socialNetworkImage
				.resizable()
				.frame(width: 24, height: 24)
				.padding(.leading, 16)
			TextField("", text: self.$item.url, onEditingChanged: { isEditing in
				debugPrint("SocialListItemView onEditingChanged: isEditing: \(isEditing)")
				self.viewModel.socialNetworkDidEdited(item: item, isEditing: isEditing)
			})
			.onSubmit {
				debugPrint("SocialListItemView onSubmit")
				self.viewModel.socialNetworkDidSubmitted(item: item)
			}
			.frame(height: 30)

			viewModel.resources.dragDropImage.padding(.trailing, 16)
		}
	}
}

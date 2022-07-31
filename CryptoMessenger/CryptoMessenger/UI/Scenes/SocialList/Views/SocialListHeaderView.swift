import SwiftUI

struct SocialListHeaderView: View {

	var body: some View {
		HStack(alignment: .bottom) {
			Text(R.string.localizable.profileNetworkDetailNotShowMessage())
				.font(.bold(12))
				.foreground(.darkGray())
		}
	}
}

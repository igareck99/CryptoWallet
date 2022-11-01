import SwiftUI

// MARK: - SocialNetworkView

struct SocialNetworkView: View {

    // MARK: - Internal Properties

    @Binding var safariAddress: String
    @Binding var showSafari: Bool
    var item: SocialListItem

    // MARK: - Body

    var body: some View {
        VStack {
            Button(action: {
				guard URL(string: item.fullUrl) != nil else { return }
                showSafari = true
                safariAddress = item.fullUrl
            }, label: {
                switch item.socialType {
                case .twitter:
                    R.image.profile.twitter.image
                case .facebook:
                    R.image.profile.facebook.image
                case .instagram:
                    R.image.profile.instagram.image
                case .vk:
                    R.image.socialNetworks.vkIcon.image.resizable()
                        .frame(width: 16,
                               height: 15)
                case .linkedin:
                    R.image.socialNetworks.linkedinIcon.image.resizable()
                        .frame(width: 16,
                               height: 15)
                case .tiktok:
                    R.image.socialNetworks.tiktokIcon.image.resizable()
                        .frame(width: 16,
                               height: 15)
                }
            }).frame(width: 32, height: 32, alignment: .center)
                .background(.blue())
                .cornerRadius(16)
        }
    }
}

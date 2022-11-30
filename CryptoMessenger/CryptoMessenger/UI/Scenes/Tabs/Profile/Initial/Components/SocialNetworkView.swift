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
                    R.image.socialNetworks.twitter.image.resizable()
                        .frame(width: 17.6,
                               height: 14)
                case .facebook:
                    R.image.socialNetworks.facebook.image.resizable()
                        .frame(width: 10.8,
                               height: 20.7)
                case .instagram:
                    R.image.socialNetworks.instagram.image.resizable()
                        .frame(width: 18,
                               height: 18)
                case .vk:
                    R.image.socialNetworks.vk.image.resizable()
                        .frame(width: 19.8,
                               height: 12.6)
                case .linkedin:
                    R.image.socialNetworks.linkedin.image.resizable()
                        .frame(width: 13.5,
                               height: 12.8)
                case .tiktok:
                    R.image.socialNetworks.tiktok.image.resizable()
                        .frame(width: 17,
                               height: 19.3)
                }
            }).frame(width: 32, height: 32, alignment: .center)
                .background(.blue())
                .cornerRadius(16)
        }
    }
}

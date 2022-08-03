import Foundation

enum SocialNetworkType: String, CaseIterable {

	case twitter
	case facebook
	case vk
	case instagram
	case linkedin
	case tiktok

	var description: String {
		switch self {
		case .facebook:
			return "facebook"
		case .twitter:
			return "twitter"
		case .vk:
			return "vk"
		case .instagram:
			return "instagram"
		case .tiktok:
			return "tiktok"
		case .linkedin:
			return "linkedin"
		}
	}

	static let baseUrlsByType: [Self: String] = [
		.twitter: "https://twitter.com/",
		.facebook: "https://www.facebook.com/",
		.vk: "https://vk.com/",
		.instagram: "https://instagram.com/",
		.linkedin: "https://www.linkedin.com/",
		.tiktok: "https://www.tiktok.com/"
	]

	static func networkType(item: String) -> SocialNetworkType {
		SocialNetworkType(rawValue: item) ?? .facebook
	}
}

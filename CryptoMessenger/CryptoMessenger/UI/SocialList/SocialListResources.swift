import Foundation
import SwiftUI

protocol SocialListResourcesable {

	var dragDropImage: Image { get }

	var detailMain: String { get }

	var detailMessage: String { get }

	var detailTitle: String { get }

	var rightButton: String { get }

	var notShowMessage: String { get }
    
    var textColor: Color { get }
    
    var buttonBackround: Color { get }
    
    var avatarBackground: Color { get }
}

struct SocialListResources {

}

// MARK: - SocialListResourcesable

extension SocialListResources: SocialListResourcesable {

	var dragDropImage: Image {
        R.image.socialNetworks.list.image
	}

	var detailMain: String {
		R.string.localizable.profileNetworkDetailMain()
	}

	var detailMessage: String {
		R.string.localizable.profileNetworkDetailMessage()
	}

	var detailTitle: String {
		R.string.localizable.profileNetworkDetailTitle()
	}

	var rightButton: String {
		R.string.localizable.profileDetailRightButton()
	}

	var notShowMessage: String {
		R.string.localizable.profileNetworkDetailNotShowMessage()
	}
    
    var textColor: Color {
        .romanSilver
    }
    
    var avatarBackground: Color {
        .dodgerTransBlue
    }
    
    var buttonBackround: Color {
        .dodgerBlue
    }
}

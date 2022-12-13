import SwiftUI
import Foundation

protocol TransferViewSourcable {

	static var chatLogo: Image { get }

	static var transferSlow: String { get }

	static var transferMiddle: String { get }

	static var transferFast: String { get }
}

enum TransferViewSources: TransferViewSourcable {

	static var chatLogo: Image {
		R.image.chat.logo.image
	}

	static var transferSlow: String {
		R.string.localizable.transferSlow()
	}

	static var transferMiddle: String {
		R.string.localizable.transferMiddle()
	}

	static var transferFast: String {
		R.string.localizable.transferQuick()
	}
}

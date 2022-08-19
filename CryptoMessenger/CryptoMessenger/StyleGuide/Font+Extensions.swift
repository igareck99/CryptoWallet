import SwiftUI
import UIKit

extension Font {

	static func ultraLight(_ size: CGFloat) -> Font {
		font(size, weight: .ultraLight)
	}

	static func thin(_ size: CGFloat) -> Font {
		font(size, weight: .thin)
	}

	static func light(_ size: CGFloat) -> Font {
		font(size, weight: .light)
	}

	static func regular(_ size: CGFloat) -> Font {
		font(size, weight: .regular)
	}

	static func medium(_ size: CGFloat) -> Font {
		font(size, weight: .medium)
	}

	static func semibold(_ size: CGFloat) -> Font {
		font(size, weight: .semibold)
	}

	static func bold(_ size: CGFloat) -> Font {
		font(size, weight: .bold)
	}

	static func heavy(_ size: CGFloat) -> Font {
		font(size, weight: .heavy)
	}

	static func black(_ size: CGFloat) -> Font {
		font(size, weight: .black)
	}

	static func font(_ size: CGFloat, weight: UIFont.Weight) -> Font {
		Font(UIFont.systemFont(ofSize: size, weight: weight))
	}
}

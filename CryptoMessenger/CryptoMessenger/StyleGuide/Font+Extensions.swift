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
    
    static let largeTitleRegular34 = Font.system(size: 34)
    static let largeTitleBold34 = Font.system(size: 34, weight: .bold)
    
    static let title1Regular28 = Font.system(size: 28)
    static let title2Regular22 = Font.system(size: 22)
    static let title3Regular20 = Font.system(size: 20)
    static let title1Bold28 = Font.system(size: 28, weight: .bold)
    static let title2Bold22 = Font.system(size: 22, weight: .bold)
    static let title3Semibold20 = Font.system(size: 20, weight: .semibold)
    
    static let headlineBold17 = Font.system(size: 17, weight: .bold)
    static let headline2Semibold17 = Font.system(size: 17, weight: .semibold)
    
    static let bodyRegular17 = Font.system(size: 17)
    static let bodySemibold17 = Font.system(size: 17, weight: .semibold)
    
    static let calloutRegular16 = Font.system(size: 16)
    static let calloutMedium16 = Font.system(size: 16, weight: .medium)
    static let callout2Semibold16 = Font.system(size: 16, weight: .semibold)
    
    static let subheadlineRegular15 = Font.system(size: 15)
    static let subheadline2Regular14 = Font.system(size: 14)
    static let subheadlineMedium15 = Font.system(size: 15, weight: .medium)
    
    static let footnoteRegular13 = Font.system(size: 13)
    static let footnoteSemibold13 = Font.system(size: 13, weight: .semibold)
    
    static let caption1Regular12 = Font.system(size: 12)
    static let caption2Regular11 = Font.system(size: 11)
    static let caption3Regular10 = Font.system(size: 10)
    static let caption1Medium12 = Font.system(size: 12, weight: .medium)
    static let caption2Semibold11 = Font.system(size: 11, weight: .semibold)
    static let caption3Medium10 = Font.system(size: 10, weight: .medium)
    
}

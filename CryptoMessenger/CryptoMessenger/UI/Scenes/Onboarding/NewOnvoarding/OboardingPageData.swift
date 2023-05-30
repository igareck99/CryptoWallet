import SwiftUI

// MARK: - OboardingPageData

enum OboardingPageData: CaseIterable {

    // MARK: - Cases

    case pageOne
    case pageTwo
    case pageThree

    // MARK: - Internal Properties

    var image: Image {
        switch self {
        case .pageOne:
            return R.image.onboarding.onboarding.page1.image
        case .pageTwo:
            return R.image.onboarding.onboarding.page2.image
        case .pageThree:
            return R.image.onboarding.onboarding.page3.image
        }
    }

    var text: String {
        switch self {
        case .pageOne:
            return R.string.localizable.onboardingPage1()
        case .pageTwo:
            return R.string.localizable.onboardingPage2()
        case .pageThree:
            return R.string.localizable.onboardingPage3()
        }
    }

    var topPadding: CGFloat {
        switch self {
        case .pageOne:
            return CGFloat(37)
        case .pageTwo:
            return CGFloat(40)
        case .pageThree:
            return CGFloat(58)
        }
    }

    var size: CGSize {
        switch self {
        case .pageOne:
            return CGSize(width: 286, height: 453)
        case .pageTwo:
            return CGSize(width: 308, height: 426)
        case .pageThree:
            return CGSize(width: 303, height: 414)
        }
    }

    var imageHorizontalPadding: CGFloat {
        switch self {
        case .pageOne:
            return CGFloat(44)
        case .pageTwo:
            return CGFloat(34)
        case .pageThree:
            return CGFloat(100)
        }
    }

    var imagePadding: CGFloat {
        switch self {
        case .pageOne, .pageTwo:
            return CGFloat(34)
        case .pageThree:
            return CGFloat(52)
        }
    }
}

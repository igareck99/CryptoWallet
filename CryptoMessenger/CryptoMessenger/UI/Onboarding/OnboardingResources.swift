import SwiftUI

// MARK: - ReserveCopyResourcable

protocol OnboardingResourcable {

    static var continueText: String { get }

    static var pageOne: Image { get }

    static var pageTwo: Image { get }

    static var pageThree: Image { get }
    
    static var buttonBackground: Color { get }
    
    static var background: Color { get }
    
    static var innactiveButtonBackground: Color { get }
    
}

// MARK: - OnboardingResources(OnboardingResourcable)

enum OnboardingResources: OnboardingResourcable {

    static var continueText: String {
        R.string.localizable.onboardingContinueButton()
    }

    static var pageOne: Image {
        R.image.onboarding.page1.image
    }

    static var pageTwo: Image {
        R.image.onboarding.page2.image
    }

    static var pageThree: Image {
        R.image.onboarding.page3.image
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var background: Color {
        .white 
    }
    
    static var innactiveButtonBackground: Color {
        .ashGray
    }
}

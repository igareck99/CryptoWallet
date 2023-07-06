import SwiftUI

protocol OnboardingSceneDelegate: AnyObject {
    func onFinishOnboarding()
}

// MARK: - OnboardingViewModelDelegate

protocol OnboardingViewModelDelegate: ObservableObject {
        
    func handleContinueButtonTap()
    
    var screens: [OboardingPageData] { get }
    
    var continueText: String { get }
}

// MARK: - OnboardingViewModel

final class OnboardingViewModel: ObservableObject, OnboardingViewModelDelegate {

    // MARK: - Internal Properties

    var delegate: OnboardingSceneDelegate?
    let sources: OnboardingResourcable.Type
    let screens: [OboardingPageData] = OboardingPageData.allCases
    var continueText = ""

    // MARK: - Private Properties

    private let userFlows: UserFlowsStorage

    // MARK: - Lifecycle

    init(
        delegate: OnboardingSceneDelegate?,
        sources: OnboardingResourcable.Type,
        userFlows: UserFlowsStorage
    ) {
        self.delegate = delegate
        self.sources = sources
        self.userFlows = userFlows
        updateData()
    }

    // MARK: - Internal Methods

    func handleContinueButtonTap() {
        userFlows.isOnboardingFlowFinished = true
        delegate?.onFinishOnboarding()
    }

    // MARK: - Private Methods

    private func updateData() {
        continueText = sources.continueText
    }
}

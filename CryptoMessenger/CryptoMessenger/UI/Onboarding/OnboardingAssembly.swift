import SwiftUI

enum OnboardingAssembly {
    static func build(delegate: OnboardingSceneDelegate?) -> some View {
        let userFlows = UserDefaultsService.shared
        let resources = OnboardingResources.self
        let viewModel = OnboardingViewModel(delegate: delegate,
                                            resources: resources,
                                            userFlows: userFlows)
        viewModel.delegate = delegate
        let view = OnboardingView(
            viewModel: viewModel
        )
        return view
    }
}

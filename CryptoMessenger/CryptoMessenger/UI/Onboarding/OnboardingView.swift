import SwiftUI

// MARK: - OnboardingView

struct OnboardingView<ViewModel>: View where ViewModel: OnboardingViewModelDelegate {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel

    // MARK: - Private Properties

    @State private var currentTab = 0

    // MARK: - Body

    var body: some View {
        content
    }

    private var content: some View {
        VStack {
            TabView(selection: $currentTab) {
                ForEach(Array(viewModel.screens.enumerated()), id: \.element) { index, value in
                    VStack(spacing: 0) {
                        Spacer()
                        VStack(alignment: .center, spacing: value.topPadding) {
                            value.image
                                .resizable()
                                .scaledToFit()
                            Text(value.text)
                                .font(.title2Regular22)
                                .multilineTextAlignment(.center)
                        }.padding()
                        Spacer()
                    }
                    .tag(index)
                    .padding(.top, 32)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            VStack {
                VStack(spacing: 32) {
                    tabsViews()
                        .padding(.bottom, currentTab == 2 ? 0 : 113)
                    if currentTab == 2 {
                        VStack {
                            registrationButton
                                .padding(.horizontal, 69)
                                .padding(.bottom, 33)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    func tabsViews() -> some View {
        HStack(spacing: 8) {
            ForEach(0..<viewModel.screens.count) { value in
                if value == currentTab {
                    RoundedRectangle(cornerRadius: 32)
                        .foregroundColor(viewModel.resources.buttonBackground)
                        .frame(width: 24, height: 8)
                } else {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(value < currentTab ? viewModel.resources.buttonBackground : viewModel.resources.innactiveButtonBackground)
                }
            }
        }
    }

    private var registrationButton: some View {
        Button {
            viewModel.handleContinueButtonTap()
        } label: {
            Text(viewModel.continueText)
                .font(.bodySemibold17)
                .frame(maxWidth: .infinity)
                .foregroundColor(viewModel.resources.background)
                .padding()
        }
        .background(viewModel.resources.buttonBackground)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .cornerRadius(8)
    }
}

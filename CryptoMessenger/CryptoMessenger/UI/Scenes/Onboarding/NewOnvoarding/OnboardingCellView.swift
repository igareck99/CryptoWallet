import SwiftUI

// MARK: - OnboardingCellView

struct OnboardingCellView: View {

    // MARK: - Internal Properties

    let data: OboardingPageData
    var registrationButtonTap: () -> Void

    @State private var isAnimating = false

    var body: some View {
        VStack {
            VStack(spacing: data.topPadding) {
                HStack {
                    Spacer()
                    data.image
                        .resizable()
                        .scaledToFill()
                    Spacer()
                }
                .padding(.horizontal, 16)
                    .padding(.top, data.imagePadding)
                Text(data.text)
                    .font(.regular(22))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }
}

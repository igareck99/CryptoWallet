import SwiftUI

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func navigationBarColor(
        _ backgroundColor: Palette?,
        titleColor: Palette? = nil,
        isBlured: Bool = true
    ) -> some View {
        modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor, isBlured: isBlured))
    }
}

// MARK: - NavigationBarModifier

struct NavigationBarModifier: ViewModifier {

    // MARK: - Internal Properties

    var backgroundColor: Palette?
    var titleColor: Palette?
    var isBlured: Bool

    // MARK: - Lifecycle

    init(backgroundColor: Palette?, titleColor: Palette?, isBlured: Bool) {
        self.backgroundColor = backgroundColor
        self.isBlured = isBlured

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundColor = .clear
        let backImage: UIImage?
        if let titleColor = titleColor {
            backImage = R.image.navigation.backButton()?.withTintColor(titleColor.uiColor, renderingMode: .alwaysTemplate)
        } else {
            backImage = R.image.navigation.backButton()?.withRenderingMode(.alwaysOriginal)
        }

        standardAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        standardAppearance.titleAttributes(
            [
                .color(titleColor ?? .black()),
                .font(.semibold(17)),
                .kern(-0.5),
                .paragraph(.init(lineHeightMultiple: 1.08, alignment: .center))
            ]
        )
        standardAppearance.largeTitleAttributes(
            [.color(titleColor ?? .black()),
             .font(.bold(34)),
             .kern(-1),
             .paragraph(.init(lineHeightMultiple: 0.93, alignment: .left))
            ]
        )

        standardAppearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]

        let barAppearance = UINavigationBar.appearance()
        barAppearance.standardAppearance = standardAppearance
        barAppearance.compactAppearance = standardAppearance
        barAppearance.scrollEdgeAppearance = standardAppearance
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                GeometryReader { geometry in
                    if let backgroundColor = backgroundColor {
                        if isBlured {
                            BlurView(style: .regular)
                                .frame(height: geometry.safeAreaInsets.top)
                                .edgesIgnoringSafeArea(.top)
                        } else {
                            Color(backgroundColor)
                                .frame(height: geometry.safeAreaInsets.top)
                                .edgesIgnoringSafeArea(.top)
                        }
                    }

                    Spacer()
                }
            }
        }
        .navigationBarHidden(backgroundColor == nil)
    }
}

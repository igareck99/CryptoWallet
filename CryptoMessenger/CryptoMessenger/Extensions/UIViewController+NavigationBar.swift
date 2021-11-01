import UIKit

// MARK: - UIViewController ()

extension UIViewController {

    // MARK: - Internal Methods

    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setupDefaultNavigationBar() {
        navigationController?.navigationBar.setTranslucent(tintColor: .black(), titleColor: .white())
        setupBackButton()
    }

    func setupClearNavigationBar() {
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.background(.clear)
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = nil
        navigationController?.navigationBar.tintColor(.clear)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor(.clear)
        navigationController?.navigationBar.isTranslucent = true

        setupBackButton(.white())
    }

    func setupTranslucentNavigationBar() {
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.background(.clear)
        navigationController?.navigationBar.barTintColor(.clear)

        setupBackButton(.clear)
    }

    func setupBlackNavigationBar() {
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.background(.darkBlack())
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = nil
        navigationController?.navigationBar.tintColor(.white())
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barTintColor(.darkBlack())
        navigationController?.navigationBar.isTranslucent = true
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.09
        paragraph.alignment = .left

        navigationController?.navigationBar.titleAttributes(
            [
                .font(.semibold(15)),
                .color(.white()),
                .paragraph(paragraph)
            ]
        )

    }

    // MARK: - Private Methods

    private func setupBackButton(_ color: Palette = .black()) {
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )

        let backImage = R.image.navigation.backButton()?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(color.uiColor)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
}

extension UINavigationBar {
    func setOpaque(tintColor: Palette, titleColor: Palette) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = tintColor.uiColor
            appearance.titleTextAttributes = [.foregroundColor: tintColor.uiColor]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            setBackgroundImage(UIImage(), for: .any, barMetrics: .defaultPrompt)
            shadowImage = UIImage()
            barTintColor = tintColor.uiColor
            titleTextAttributes = [.foregroundColor: tintColor.uiColor]
        }
        isTranslucent = false
        self.tintColor = tintColor.uiColor
    }

    func setTranslucent(tintColor: Palette, titleColor: Palette) {
        var paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.09
        paragraph.alignment = .left

        UIBarButtonItem.appearance().titleAttributes(
            [
                .color(.black()),
                .font(.semibold(17)),
                .paragraph(paragraph)
            ],
            for: .normal
        )
        UIBarButtonItem.appearance().titleAttributes(
            [
                .color(.black()),
                .font(.semibold(17)),
                .paragraph(paragraph)
            ],
            for: .highlighted
        )

        paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.09
        paragraph.alignment = .center

        titleAttributes(
            [
                .font(.regular(15)),
                .color(.black()),
                .paragraph(paragraph)
            ]
        )

        background(.white())

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .white
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor.uiColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor.uiColor]

        standardAppearance = coloredAppearance
        compactAppearance = coloredAppearance
        scrollEdgeAppearance = coloredAppearance

        isTranslucent = true
        self.tintColor = tintColor.uiColor
    }
}

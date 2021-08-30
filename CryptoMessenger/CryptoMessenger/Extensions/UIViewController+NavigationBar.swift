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
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.background(.white())
        navigationController?.navigationBar.tintColor(.black())
        navigationController?.navigationBar.barTintColor(.white())
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.4
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowRadius = 0.5
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = nil

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

        navigationController?.navigationBar.titleAttributes(
            [
                .font(.regular(15)),
                .color(.black()),
                .paragraph(paragraph)
            ]
        )

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

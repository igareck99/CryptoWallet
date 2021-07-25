import UIKit

// MARK: - OnboardingViewController

final class OnboardingViewController: BaseViewController {

    // MARK: - Types

    typealias OnboardingPage = OnboardingPresenter.OnboardingPage

    // MARK: - Internal Properties

    var presenter: OnboardingPresentation!

    // MARK: - Private Properties

    private lazy var continueButton = UIButton()
    private lazy var infoLabel = UILabel()
    private lazy var policyButton = UIButton()

    private var pageController: UIPageViewController!
    private var isLastShown = false
    private var controllers: [UIViewController] = []
    private var currentPage: Int = 0 {
        didSet {
            guard controllers.indices.contains(currentPage),
                  controllers.indices.contains(oldValue),
                  currentPage != oldValue else { return }
            decorateControls(oldValue)
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.background(.white())
        hideNavigationBar()
        setupPageView()
        addContinueButton()
        addInfoLabel()
        addPolicyButton()
        setViewControllers()
    }

    // MARK: - Actions

    @objc private func continueButtonTap() {
        nextButtonTap()
    }

    @objc private func policyButtonTap() {

    }

    // MARK: - Private Methods

    private func addContinueButton() {
        continueButton.snap(parent: view) {
            let title = R.string.localizable.onboardingContinueButton()
            $0.titleAttributes(text: title, [.color(.blue()), .font(.medium(15))])
            $0.background(.lightBlue())
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.continueButtonTap), for: .touchUpInside)
        } layout: {
            $0.bottom.equalTo($1).offset(-122)
            $0.leading.equalTo($1).offset(80)
            $0.trailing.equalTo($1).offset(-80)
            $0.height.equalTo(44)
        }
    }

    private func addInfoLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.04
        paragraphStyle.alignment = .center

        infoLabel.snap(parent: view) {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.titleAttributes(
                text: R.string.localizable.onboardingInformation(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(13)),
                    .color(.gray())
                ]
            )
        } layout: {
            $0.top.equalTo(self.continueButton.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
        }
    }

    private func addPolicyButton() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.04
        paragraphStyle.alignment = .center

        policyButton.snap(parent: view) {
            let title = R.string.localizable.onboardingPolicy()
            $0.titleAttributes(text: title, [.color(.blue()), .font(.regular(13)), .paragraph(paragraphStyle)])
            $0.addTarget(self, action: #selector(self.policyButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.infoLabel.snp_bottomMargin)
            $0.centerX.equalTo($1)
        }
    }

    private func setupPageView() {
        pageController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageController.dataSource = self
        pageController.delegate = self
        pageController.willMove(toParent: self)
        pageController.view.snap(parent: view, layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        })

        addChild(pageController)
        pageController.didMove(toParent: self)
    }

    private func setViewControllers() {
        presenter.pages.forEach {
            let vc = OnboardingPageViewController()
            vc.onNextPageTap = { [weak self] in
                self?.nextButtonTap()
            }
            vc.setPage($0)
            controllers.append(vc)
        }

        pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
    }

    private func nextButtonTap() {
        guard currentPage != controllers.count - 1, !isLastShown else {
            continueButton.animateScaleEffect {
                self.presenter.handleContinueButtonTap()
            }
            return
        }

        currentPage += 1

        guard let currentViewController = pageController.viewControllers?.first,
              let index = controllers.firstIndex(of: currentViewController) else { return }

        pageController.setViewControllers(
            [controllers[index + 1]],
            direction: .forward,
            animated: true
        )
    }

    private func decorateControls(_ oldValue: Int) {
        isLastShown = currentPage == controllers.count - 1
    }
}

// MARK: - OnboardingViewController (UIPageViewControllerDataSource)

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
            } else {
                return nil
            }
        }
        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            } else {
                return nil
            }
        }
        return nil
    }
}

// MARK: - PermissionsOnboardingViewController (UIPageViewControllerDelegate)

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let pageContentViewController = pageViewController.viewControllers?.first else {
            currentPage = 0
            return
        }
        currentPage = controllers.firstIndex(of: pageContentViewController) ?? 0
    }
}

// MARK: - OnboardingViewController (OnboardingViewInterface)

extension OnboardingViewController: OnboardingViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}

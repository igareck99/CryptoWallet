import UIKit

// MARK: - OnboardingViewController

final class OnboardingViewController: BaseViewController {

    // MARK: - Types

    typealias OnboardingPage = OnboardingPresenter.OnboardingPage

    // MARK: - Internal Properties

    var presenter: OnboardingPresentation!

    // MARK: - Private Properties

    private lazy var continueButton = UIButton()
    private lazy var tutorialButton = UIButton()
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

    private lazy var dotesStackView = UIStackView()
    private lazy var dotes: [UIView] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.background(.white())
        showNavigationBar()
        hideNavigationBar()
        setupPageView()
        addDotesStackView()
        addInfoLabel()
        addPolicyButton()
        addContinueButton()
        addTutorialButton()
        setViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTranslucentNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        decorateControls(currentPage)
    }

    // MARK: - Actions

    @objc private func continueButtonTap() {
        nextButtonTap()
    }

    @objc private func tutorialButtonTap() {

    }

    @objc private func policyButtonTap() {

    }

    // MARK: - Private Methods

    private func addContinueButton() {
        continueButton.snap(parent: view) {
            $0.titleAttributes(
                text: R.string.localizable.onboardingContinueButton(),
                [
                    .color(.white()),
                    .font(.semibold(15)),
                    .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                ]
            )
            $0.isHidden = true
            $0.background(.blue())
            $0.clipCorners(radius: 8)
            $0.addTarget(self, action: #selector(self.continueButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.dotesStackView.snp.bottom).offset(28)
            $0.leading.equalTo($1).offset(67)
            $0.trailing.equalTo($1).offset(-67)
            $0.height.equalTo(44)
        }
    }

    private func addTutorialButton() {
        tutorialButton.snap(parent: view) {
            $0.titleAttributes(
                text: R.string.localizable.onboardingTutorialButton(),
                [
                    .color(.blue()),
                    .font(.semibold(15)),
                    .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                ]
            )
            $0.isHidden = true
            $0.background(.clear)
            $0.addTarget(self, action: #selector(self.tutorialButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.continueButton.snp_bottomMargin).offset(21)
            $0.leading.equalTo($1).offset(67)
            $0.trailing.equalTo($1).offset(-67)
            $0.height.equalTo(44)
        }
    }

    private func addInfoLabel() {
        infoLabel.snap(parent: view) {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.titleAttributes(
                text: R.string.localizable.onboardingInformation(),
                [
                    .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center)),
                    .font(.regular(13)),
                    .color(.gray())
                ]
            )
        } layout: {
            $0.top.equalTo(self.dotesStackView.snp.bottom).offset(75)
            $0.leading.equalTo($1).offset(24)
            $0.trailing.equalTo($1).offset(-24)
        }
    }

    private func addPolicyButton() {
        policyButton.snap(parent: view) {
            let title = R.string.localizable.onboardingPolicy()
            $0.titleAttributes(
                text: title,
                [
                    .color(.blue()),
                    .font(.regular(13)),
                    .paragraph(.init(lineHeightMultiple: 1.09, alignment: .center))
                ]
            )
            $0.addTarget(self, action: #selector(self.policyButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.equalTo(self.infoLabel.snp_bottomMargin).offset(2)
            $0.centerX.equalTo($1)
        }
    }

    private func addDotesStackView() {
        dotesStackView.snap(parent: view) {
            $0.axis = .horizontal
            $0.spacing = 11
            $0.alignment = .fill
        } layout: {
            $0.top.equalTo(self.pageController.view.snp.bottom).offset(24)
            $0.height.equalTo(9)
            $0.centerX.equalTo($1)
        }

        (0..<presenter.pages.count).forEach { index in
            let dote = UIView()
            dote.clipCorners(radius: 4.5)
            if index == 0 {
                dote.background(.blue())
            } else {
                dote.layer.borderWidth(1)
                dote.layer.borderColor(.blue())
            }

            dote.snp.makeConstraints {
                $0.width.height.equalTo(9)
            }
            dotes.append(dote)
            dotesStackView.addArrangedSubview(dote)
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
            $0.top.equalTo($1).offset(54)
            $0.leading.trailing.equalTo($1)
            $0.bottom.equalTo($1).offset(-200)
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

        continueButton.isHidden = !isLastShown
        tutorialButton.isHidden = !isLastShown
        infoLabel.isHidden = isLastShown
        policyButton.isHidden = isLastShown

        UIView.transition(with: dotesStackView, duration: 0.2, options: .transitionCrossDissolve) {
            self.dotes.enumerated().forEach { result in
                if result.offset == self.currentPage {
                    result.element.background(.blue())
                    result.element.layer.borderWidth(0)
                    result.element.layer.borderColor(.clear)
                } else {
                    result.element.background(.white())
                    result.element.layer.borderWidth(1)
                    result.element.layer.borderColor(.blue())
                }
            }
        }
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

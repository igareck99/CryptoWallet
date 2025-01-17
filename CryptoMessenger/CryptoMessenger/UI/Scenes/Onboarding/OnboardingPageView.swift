import UIKit

// MARK: - OnboardingPageView

final class OnboardingPageView: UIView {

    // MARK: - Types

    typealias OnboardingPage = OnboardingViewController.OnboardingPage

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = .init()
    private lazy var iconImageView: UIImageView = .init()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addIconImageView()
        addTitleLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func setPage(_ page: OnboardingPage) {
        titleLabel.titleAttributes(
            text: page.title.uppercased(),
            [
                .font(.bold(15)),
                .paragraph(.init(lineHeightMultiple: 1.42, alignment: .center)),
                .color(.black()),
                .kern(0.07)
            ]
        )
        iconImageView.image = page.image
    }

    // MARK: - Private Methods

    private func addIconImageView() {
        iconImageView.snap(parent: self) {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        } layout: {
            $0.top.equalTo($1).offset(54)
            $0.height.equalTo(UIScreen.main.bounds.height - 420)
            $0.centerX.equalTo($1)
        }
    }

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font(.medium(17))
            $0.textColor(.black())
        } layout: {
            $0.top.equalTo(self.iconImageView.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(20)
            $0.height.lessThanOrEqualTo(70)
            $0.trailing.equalTo($1).offset(-20)
        }
    }
}

import UIKit

// MARK: - OnboardingView

final class OnboardingView: UIView {

    // MARK: - Internal Properties

    var didNextSceneTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = .init()
    private lazy var descriptionLabel: UILabel = .init()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addTitleLabel()
        addDescriptionLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.text = "Title"
            $0.textAlignment = .center
            $0.textColor(.black())
            $0.font(.regular(22))
        } layout: {
            $0.top.equalTo($1).offset(44)
            $0.leading.equalTo($1).offset(15)
            $0.trailing.equalTo($1).offset(-15)
        }
    }

    private func addDescriptionLabel() {
        descriptionLabel.snap(parent: self) {
            $0.text = "Description"
            $0.textAlignment = .center
            $0.textColor(.blue())
            $0.font(.medium(18))
        } layout: {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo($1).offset(15)
            $0.trailing.equalTo($1).offset(-15)
        }
    }
}

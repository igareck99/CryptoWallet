import UIKit

// MARK: - QuestionCell

final class QuestionCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var questionLabel = UILabel()
    private lazy var openButton = UIButton()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addQuestionLabel()
        addOpenButton()

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: QuestionItem) {
        questionLabel.text = profile.text
        if profile.type == 0 {
            openButton.setImage(R.image.answersQuestion.downArrow(), for: .normal)
        } else {
            openButton.setImage(R.image.answersQuestion.upArrow(), for: .normal)
        }
    }

    // MARK: - Private Methods

    private func addQuestionLabel() {
        questionLabel.snap(parent: self) {
            $0.font(.light(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo($1).offset(21)
        }
    }

    private func addOpenButton() {
        openButton.snap(parent: self) {
            $0.contentMode = .center
        } layout: {
            $0.width.equalTo(24)
            $0.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-23)
            $0.top.equalTo($1).offset(22)
        }
    }
}

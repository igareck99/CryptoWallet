import UIKit

// MARK: - LanguageCell

final class LanguageCell: UITableViewCell {

    // MARK: - Internal Properties

    var didTap: VoidBlock?

    // MARK: - Private Properties

    private lazy var mainLabel = UILabel()
    private lazy var nativeLabel = UILabel()
    private lazy var selectedImageView = UIImageView()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addMainLabel()
        addNativeLabel()
        addArrowImageView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: LanguageItem) {
        mainLabel.text = profile.currentLanguage
        nativeLabel.text = profile.nativeLanguage
        selectedImageView.isHidden = !profile.isSelected
    }

    // MARK: - Private Methods

    private func addMainLabel() {
        mainLabel.snap(parent: contentView) {
            $0.font(.regular(15))
            $0.textColor(.black())
        } layout: {
            $0.height.equalTo(21)
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo($1).offset(12)
        }
    }

    private func addNativeLabel() {
        nativeLabel.snap(parent: contentView) {
            $0.textColor(.gray())
            $0.font(.light(13))
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.mainLabel.snp.bottom).offset(4)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addArrowImageView() {
        selectedImageView.snap(parent: contentView) {
            $0.contentMode = .center
            $0.image = R.image.countryCode.check()
        } layout: {
            $0.width.height.equalTo(24)
            $0.trailing.equalTo($1).offset(-16)
            $0.bottom.equalTo($1).offset(-20)
        }
    }
}
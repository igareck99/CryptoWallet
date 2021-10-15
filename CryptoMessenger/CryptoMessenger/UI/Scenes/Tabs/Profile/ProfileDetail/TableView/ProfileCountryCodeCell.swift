import UIKit
import PhoneNumberKit

// MARK: - ProfileDetailDelegate

protocol ProfileCountryCodeDelegate: AnyObject {
    func update(_ cell: UITableViewCell, _ textView: UITextView)
}

// MARK: - ProfileDetailCell

final class ProfileCountryCodeCell: UITableViewCell {

    // MARK: - Type

    typealias Country = CountryCodePickerViewController.Country

    // MARK: - Internal Properties

    weak var delegate: ProfileCountryCodeDelegate?
    var didTapCountryScene: VoidBlock?

    // MARK: - Private Properties

    private lazy var countryView = UIView()
    private lazy var countryLabel = UILabel()
    private lazy var arrowImageView = UIImageView()
    private lazy var countryButton = UIButton()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addCountryView()
        addCountryLabel()
        addArrowImageView()
        addCountryButton()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ text: String) {
        countryLabel.text = text
    }

    func setCountryCode(_ country: CountryCodePickerViewController.Country) {
        countryLabel.text = country.prefix + " " + country.name.firstUppercased
    }

    // MARK: - Private Methods

    @objc private func countryButtonTap() {
        vibrate()
        countryView.animateScaleEffect { self.didTapCountryScene?() }
    }

    private func addCountryView() {
        countryView.snap(parent: self) {
            $0.background(.paleBlue())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.top.equalTo($1)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
            $0.height.equalTo(44)
        }
    }

    private func addCountryLabel() {
        countryLabel.snap(parent: countryView) {
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.textAlignment = .left
        } layout: {
            $0.centerY.equalTo($1)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addArrowImageView() {
        arrowImageView.snap(parent: countryView) {
            $0.image = R.image.registration.arrow()
        } layout: {
            $0.centerY.equalTo($1)
            $0.leading.equalTo(self.countryLabel.snp.trailing).offset(16)
            $0.trailing.equalTo($1).offset(-10)
            $0.width.height.equalTo(24)
        }
    }

    private func addCountryButton() {
        countryButton.snap(parent: countryView) {
            $0.background(.clear)
            $0.isUserInteractionEnabled = true
            $0.addTarget(self, action: #selector(self.countryButtonTap), for: .touchUpInside)
        } layout: {
            $0.top.leading.trailing.bottom.equalTo($1)
        }
    }
}

// MARK: - ProfileCountryCodeCell (UITextViewDelegate)

extension ProfileCountryCodeCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.update(self, textView)
    }
}

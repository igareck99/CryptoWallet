import UIKit

// MARK: - CallStruct

struct CallStruct {
    var name: String
    var dateTime: String
    var image: UIImage!
}

class CallCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var name = UILabel()
    private lazy var date = UILabel()
    private lazy var profileImage = UIImageView()
    private lazy var phonebutton = UIButton()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addProfileImage()
        addName()
        addDateTime()
        addPhoneButton()
    }
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func configure(_ profile: CallStruct) {
        name.text = profile.name
        date.text = profile.dateTime
        profileImage.image = profile.image
        phonebutton.setImage(R.image.callList.bluePhone(), for: .normal)
    }

    // MARK: - Private Methods

    private func addProfileImage() {
        profileImage.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.clipCorners(radius: 20)
        } layout: {
            $0.width.height.equalTo(40)
            $0.leading.equalTo($1).offset(16)
            $0.top.equalTo(self.snp_topMargin).offset(16)
        }
    }

    private func addName() {
        name.snap(parent: self) {
            $0.font(.medium(15))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(68)
            $0.top.equalTo(self.snp_topMargin).offset(17)
        }
    }

    private func addDateTime() {
        date.snap(parent: self) {
            $0.font(.light(13))
            $0.textColor(.black())
        } layout: {
            $0.leading.equalTo($1).offset(84)
            $0.top.equalTo(self.name.snp.bottom).offset(4)
        }
    }

    private func addPhoneButton() {
        phonebutton.snap(parent: self) {
            $0.contentMode = .scaleAspectFill
        } layout: {
            $0.width.height.equalTo(24)
            $0.leading.equalTo($1).offset(339)
            $0.trailing.equalTo($1).offset(-20)
            $0.top.equalTo(self.snp_topMargin).offset(29)
        }
    }
}

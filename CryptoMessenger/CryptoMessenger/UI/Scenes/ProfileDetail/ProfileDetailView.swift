import UIKit

// MARK: - ProfileDetailView

final class ProfileDetailView: UIView {

    // MARK: - Internal Properties

    var didTapReady: VoidBlock?
    var didDeleteTap: VoidBlock?
    var didLogoutTap: VoidBlock?
    var didTapAddPhoto: VoidBlock?

    // MARK: - Private Properties

    private lazy var scrollView = UIScrollView()
    private lazy var profileImage = UIImageView()
    private lazy var cameraButton = UIButton()
    private lazy var statusLabel = UILabel()
    private lazy var infoLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var statusView = UITextView()
    private lazy var infoView = UITextView()
    private lazy var nameField = UITextField()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: ProfileDetailViewModel = .init(tableList) {
        didSet {
            if tableProvider == nil {
                setupTableProvider()
            }
            tableProvider?.reloadData()
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addScrollView()
        addImageView()
        addCameraButton()
        addStatusLabel()
        addStatusView()
        addInfoLabel()
        addInfoView()
        addNameLabel()
        addNameField()
        setupTableView()
        setupTableProvider()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func saveData() {
        profileDetail.info = infoView.text
        profileDetail.status = statusView.text
        profileDetail.name = nameField.text ?? ""
        print("ProfileDetail   Status  \(profileDetail.status)")
        print("ProfileDetail  Info   \(profileDetail.info)")
        print("ProfileDetail  Name   \(profileDetail.name)")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.statusView.resignFirstResponder()
        self.infoView.resignFirstResponder()
        self.nameField.resignFirstResponder()
    }

    func addImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.profileImage.image = image
                }
        profileDetail.image = image
    }

    // MARK: - Actions

    @objc func deleteAccount() {
        didDeleteTap?()
    }

    @objc func logout() {
        didLogoutTap?()
    }

    @objc private func addPhoto() {
        didTapAddPhoto?()
    }

    // MARK: - Private Methods

    private func addScrollView() {
        scrollView.snap(parent: self) {
            $0.background(.white())
        } layout: {
            $0.top.bottom.leading.trailing.equalTo($1)
        }

    }

    private func addImageView() {
        profileImage.snap(parent: scrollView) {
            $0.image = R.image.profileDetail.mainImage1()
            $0.contentMode = .scaleToFill
        } layout: {
            $0.leading.trailing.top.equalTo($1)
            $0.height.equalTo(377)
        }
    }

    private func addCameraButton() {
        cameraButton.snap(parent: self) {
            $0.setImage(R.image.profileDetail.camera(), for: .normal)
            $0.contentMode = .scaleToFill
            $0.clipCorners(radius: 30)
            $0.background(.darkBlack(0.4))
            $0.addTarget(self, action: #selector(self.addPhoto), for: .touchUpInside)
        } layout: {
            $0.width.height.equalTo(60)
            $0.trailing.equalTo($1).offset(-16)
            $0.top.equalTo($1).offset(301)
        }
    }

    private func addStatusLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        statusLabel.snap(parent: scrollView) {
            $0.titleAttributes(
                text: R.string.localizable.profileDetailStatusLabel(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.height.equalTo(22)
            $0.top.equalTo($1).offset(399)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addStatusView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        statusView.snap(parent: scrollView) {
            $0.text = profileDetail.status
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.returnKeyType = UIReturnKeyType.default
            $0.textAlignment = .left
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
            $0.isScrollEnabled = false
        } layout: {
            $0.height.greaterThanOrEqualTo(24)
            $0.top.equalTo(self.statusLabel.snp.bottom).offset(8)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addInfoLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        infoLabel.snap(parent: scrollView) {
            $0.titleAttributes(
                text: R.string.localizable.profileDetailInfoLabel(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.top.equalTo(self.statusView.snp_bottomMargin).offset(30)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addInfoView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        infoView.snap(parent: scrollView) {
            $0.text = profileDetail.info
            $0.font(.regular(15))
            $0.textColor(.black())
            $0.returnKeyType = UIReturnKeyType.default
            $0.textAlignment = .left
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
        } layout: {
            $0.height.equalTo(132)
            $0.top.equalTo(self.infoLabel.snp.bottom).offset(8)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func addNameLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        nameLabel.snap(parent: scrollView) {
            $0.titleAttributes(
                text: R.string.localizable.profileDetailNameLabel(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
            $0.textAlignment = .left
        } layout: {
            $0.height.equalTo(22)
            $0.top.equalTo(self.infoView.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(16)
        }
    }

    private func addNameField() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        nameField.snap(parent: scrollView) {
            $0.titleAttributes(
                text: profileDetail.name,
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.gray())
                ]
            )
            $0.textAlignment = .left
            $0.background(.lightGray())
            $0.clipCorners(radius: 8)
            $0.placeholder = R.string.localizable.profileDetailNameLabel()
        } layout: {
            $0.height.equalTo(44)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(24)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
    }

    private func setupTableView() {
        tableView.snap(parent: scrollView) {
            $0.register(ProfileDetailCell.self, forCellReuseIdentifier: ProfileDetailCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo(self.nameField.snp.bottom).offset(24)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([ProfileDetailCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: ProfileDetailCell = provider.dequeueReusableCell(for: indexPath)
            let item = tableModel.items[indexPath.section]
            cell.configure(item)
            return cell
        }
        tableProvider?.onViewForHeaderInSection = { [unowned self] section in
            let height = tableModel.heightForHeader(atIndex: section)
            guard height > 0 else { return nil }
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat(height)))
            let line = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
            line.background(.gray(0.4))
            header.addSubview(line)
            line.center = header.center
            return header
        }
    }
}

var profileDetail = ProfileItem(image: R.image.profileDetail.mainImage1()!,
                                status: "На расслабоне на чиле",
                                info: "Сейчас пойду пивка бахну",
                                name: "")

var tableList: [ProfileDetailItem] = [
    ProfileDetailItem(text: R.string.localizable.profileDetailFirstItemCell(),
                      image: R.image.profileDetail.firstItem(),
                      type: 0),
    ProfileDetailItem(text: R.string.localizable.profileDetailSecondItemCell(),
                      image: R.image.profileDetail.secondItem(),
                      type: 1),
    ProfileDetailItem(text: R.string.localizable.profileDetailThirdItemCell(),
                      image: R.image.profileDetail.thirdItem(),
                      type: 1)
]

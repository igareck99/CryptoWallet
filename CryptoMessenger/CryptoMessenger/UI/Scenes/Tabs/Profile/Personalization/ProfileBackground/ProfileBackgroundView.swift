import UIKit

// MARK: - ProfileBackgroundView

final class ProfileBackgroundView: UIView {

    // MARK: - Internal Properties

    var didTapAddPhoto: VoidBlock?

    // MARK: - Private Properties

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var tableProvider: TableViewProvider?
    private var tableModel: ProfileBackgroundViewModel = .init(backroundList) {
        didSet {
            if tableProvider == nil {
                setupTableProvider()
            }
            tableProvider?.reloadData()
        }
    }
    private lazy var wallpaperLabel = UILabel()
    private let spacing: CGFloat = 8
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width: CGFloat = bounds.width / 3 - 2 * spacing
        layout.itemSize = CGSize(width: width, height: width + spacing)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private(set) var photos: [UIImage?] = []

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        setupTableView()
        setupTableProvider()
        addWallpaperLabel()
        addPhotoCollectionView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func addImage(_ image: UIImage) {
        print(image)
        photos.append(image)
        photoCollectionView.reloadData()
    }

    func setPhotos(_ images: [UIImage?]) {
        photos.append(contentsOf: images)
        photoCollectionView.reloadData()
    }

    // MARK: - Private Methods

    private func setupTableView() {
        tableView.snap(parent: self) {
            $0.register(ProfileBackgroundCell.self, forCellReuseIdentifier: ProfileBackgroundCell.identifier)
            $0.separatorStyle = .none
            $0.allowsSelection = true
            $0.isScrollEnabled = false
            $0.translatesAutoresizingMaskIntoConstraints = false
        } layout: {
            $0.leading.trailing.bottom.equalTo($1)
            $0.top.equalTo($1).offset(12)
        }
    }

    private func setupTableProvider() {
        tableProvider = TableViewProvider(for: tableView, with: tableModel)
        tableProvider?.registerCells([ProfileBackgroundCell.self])
        tableProvider?.onConfigureCell = { [unowned self] indexPath in
            guard let provider = self.tableProvider else { return .init() }
            let cell: ProfileBackgroundCell = provider.dequeueReusableCell(for: indexPath)
            cell.configure(tableModel.items[indexPath.section])
            return cell
        }
        tableProvider?.onSelectCell = { [unowned self] _ in
            didTapAddPhoto?()
        }
    }

    private func addWallpaperLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .left

        wallpaperLabel.snap(parent: self) {
            $0.titleAttributes(
                text: R.string.localizable.profileBackgroundWallpaper(),
                [
                    .paragraph(paragraphStyle),
                    .font(.regular(12)),
                    .color(.darkGray())
                ]
            )
            $0.textAlignment = .left
            $0.numberOfLines = 0
        } layout: {
            $0.top.equalTo($1).offset(88)
            $0.leading.equalTo($1).offset(16)
            $0.height.equalTo(22)
        }
    }

    private func addPhotoCollectionView() {
        print("called")
        photoCollectionView.snap(parent: self) {
            $0.background(.clear)
            $0.dataSource = self
            $0.delegate = self
            $0.register(ProfileBackgroundCollectionCell.self,
                        forCellWithReuseIdentifier: ProfileBackgroundCollectionCell.identifier)
        } layout: {
            $0.top.equalTo($1).offset(120)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
        photoCollectionView.reloadData()
    }

}

// MARK: - ProfileBackgroundView (UICollectionViewDataSource)

extension ProfileBackgroundView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photos.count)
        return photos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(ProfileBackgroundCollectionCell.self, indexPath: indexPath) else { return .init() }
        cell.profileImageView.image = photos[indexPath.row]
        return cell
    }
}

// MARK: - ProfileBackgroundView (UICollectionViewDelegate)

extension ProfileBackgroundView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("some action")
    }
}

private var backroundList: [ProfileBackgroundItem] = [
    .init(text: "Выбрать из галереи фон")
]

import UIKit

// MARK: - ProfileBackgroundView

final class ProfileBackgroundView: UIView {

    // MARK: - Internal Properties

    var didTapAddPhoto: VoidBlock?

    // MARK: - Private Properties

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
        photoCollectionView.snap(parent: self) {
            $0.background(.clear)
            $0.dataSource = self
            $0.delegate = self
            $0.register(ProfileBackgroundCollectionCell.self,
                        forCellWithReuseIdentifier: ProfileBackgroundCollectionCell.identifier)
            $0.register(ProfileBackgroundHeaderView.self,
                        forSupplementaryViewOfKind:
                            UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: ProfileBackgroundCollectionCell.identifier)
        } layout: {
            $0.top.equalTo($1).offset(120)
            $0.leading.equalTo($1).offset(16)
            $0.trailing.equalTo($1).offset(-16)
        }
        photoCollectionView.reloadData()
    }

}

// MARK: - ProfileBackgroundView (UICollectionViewDataSource)

extension ProfileBackgroundView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(ProfileBackgroundCollectionCell.self,
                                                indexPath: indexPath) else { return .init() }
        cell.profileImageView.image = photos[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileBackgroundHeaderView.identifier, for: indexPath)
            as! ProfileBackgroundHeaderView
        headerView.configure(backroundList[0])
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 78)
    }
}

private var backroundList: [ProfileBackgroundItem] = [
    .init(text: "Выбрать из галереи фон")
]

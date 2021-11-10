import UIKit

// MARK: - ProfileView

final class ProfileView: UIView {

    // MARK: - Internal Properties

    var didTapAddPhoto: VoidBlock?
    var didTapShowPhoto: VoidBlock?
    var didTapBuyCell: VoidBlock?

    // MARK: - Private Properties

    private let spacing: CGFloat = 1

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
        photos.append(image)
        photoCollectionView.reloadData()
    }

    func setPhotos(_ images: [UIImage?]) {
        photos.append(contentsOf: images)
        photoCollectionView.reloadData()
    }

    // MARK: - Actions

    @objc private func BuyButtonTap() {
        didTapBuyCell?()
    }

    // MARK: - Private Methods

    private func addPhotoCollectionView() {
        photoCollectionView.snap(parent: self) {
            $0.background(.clear)
            let imageView = UIImageView()
            $0.backgroundView = imageView
            $0.dataSource = self
            $0.delegate = self
            $0.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
            $0.register(ProfileHeaderCollectionReusableView.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
            $0.register(ProfileFooterCollectionReusableView.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                        withReuseIdentifier: ProfileFooterCollectionReusableView.identifier)
        } layout: {
            $0.top.bottom.leading.trailing.equalTo($1)
        }
        photoCollectionView.reloadData()
    }
}

// MARK: - ProfileView (UICollectionViewDataSource)

extension ProfileView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(ProfileCell.self, indexPath: indexPath) else { return .init() }
        cell.profileImageView.image = photos[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath)
                    as? ProfileHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            headerView.didTapAddPhoto = {
                self.didTapAddPhoto?()
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: ProfileFooterCollectionReusableView.identifier,
                    for: indexPath) as? ProfileFooterCollectionReusableView else { return UICollectionReusableView() }
            footer.didTapBuyCell = {
                self.didTapBuyCell?()
            }
            return footer
        default:
            print()
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 329)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 141)
    }
}

// MARK: - ProfileView (UICollectionViewDelegate)

extension ProfileView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapShowPhoto?()
    }
}

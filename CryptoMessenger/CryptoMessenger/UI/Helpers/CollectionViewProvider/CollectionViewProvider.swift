import UIKit

// MARK: CollectionViewProvider

final class CollectionViewProvider: NSObject, CollectionViewProviderType {

    // MARK: - Internal Properties

    var onConfigureCell: ((IndexPath) -> UICollectionViewCell)?
    var onSelectCell: ((IndexPath) -> Void)?
    var onConfigureCellSize: ((IndexPath) -> CGSize)?

    // MARK: - Private Properties

    private let collectionView: UICollectionView
    private let viewModel: CollectionViewProviderViewModel

    // MARK: - Lifecycle

    init(collectionView: UICollectionView, viewModel: CollectionViewProviderViewModel) {
        self.viewModel = viewModel
        self.collectionView = collectionView

        super.init()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    // MARK: - Internal Methods

    func registerCells(_ cells: [UICollectionViewCell.Type]) {
        cells.forEach { registerCell($0) }
    }

    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }

    private func registerCell<T>(_ type: T.Type) where T: UICollectionViewCell {
        if let nibLoadableType = type as? NibLoadableView.Type {
            let nib = UINib(nibName: nibLoadableType.nibName, bundle: Bundle(for: type.self))
            collectionView.register(nib, forCellWithReuseIdentifier: String(describing: type))
        } else {
            collectionView.register(type.self, forCellWithReuseIdentifier: String(describing: type))
        }
    }

    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - CollectionViewProvider (UICollectionViewDataSource)

extension CollectionViewProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsIn(section: section)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let onConfigureCell = onConfigureCell else {
            fatalError("Need to init onConfigureCell")
        }
        return onConfigureCell(indexPath)
    }
}

// MARK: - CollectionViewProvider (UICollectionViewDelegate)

extension CollectionViewProvider: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectCell?(indexPath)
    }
}

// MARK: - CollectionViewProvider (UICollectionViewDelegateFlowLayout)

extension CollectionViewProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let onConfigureCellSize = onConfigureCellSize else {
            fatalError("Need to init onConfigureCellSize")
        }

        return onConfigureCellSize(indexPath)
    }
}

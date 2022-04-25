import UIKit

// MARK: - InteractionState

enum InteractionState {
    case enabled
    case disabled
}

// MARK: - LayoutState

enum LayoutState {
    case ready
    case configuring
}

// MARK: - LayoutChangeHandler

protocol LayoutChangeHandler {
    var needsUpdateOffset: Bool { get }
    var targetIndex: Int { get }
    var layoutState: LayoutState { get set }
}

// MARK: - ScrollSynchronizer

final class ScrollSynchronizer: NSObject, LayoutChangeHandler {

    // MARK: - Internal Properties

    let preview: PreviewLayout
    let thumbnails: ThumbnailLayout
    var activeIndex = 0
    var layoutStateInternal: LayoutState = .configuring
    var interactionState: InteractionState = .enabled

    var layoutState: LayoutState {
        get { layoutStateInternal }
        set(value) {
            switch value {
            case .ready:
                bind()
            case .configuring:
                unbind()
            }
            layoutStateInternal = value
        }
    }
    var needsUpdateOffset: Bool { layoutState == .configuring }
    var targetIndex: Int { activeIndex }

    // MARK: - Lifecycle

    init(preview: PreviewLayout, thumbnails: ThumbnailLayout) {
        self.preview = preview
        self.thumbnails = thumbnails
        super.init()
        self.thumbnails.layoutHandler = self
        self.preview.layoutHandler = self
        bind()
    }

    // MARK: - Internal Methods

    func reload() {
        preview.collectionView?.reloadData()
        thumbnails.collectionView?.reloadData()
    }

    // MARK: - Private Methods

    private func bind() {
        preview.collectionView?.delegate = self
        thumbnails.collectionView?.delegate = self
    }

    private func unbind() {
        preview.collectionView?.delegate = .none
        thumbnails.collectionView?.delegate = .none
    }

    private func delete(
        at indexPath: IndexPath,
        dataSourceUpdate: @escaping () -> Void,
        completion: (() -> Void)?) {

        unbind()
        interactionState = .disabled
        DeleteAnimation(thumbnails: thumbnails, preview: preview, index: indexPath).run {
            let previousCount = self.thumbnails.itemsCount
            if previousCount == indexPath.row + 1 {
                self.activeIndex = previousCount - 1
            }
            dataSourceUpdate()
            self.thumbnails.collectionView?.deleteItems(at: [indexPath])
            self.preview.collectionView?.deleteItems(at: [indexPath])
            debugPrint("removed \(indexPath)")
            self.bind()
            self.interactionState = .enabled
            completion?()
        }
    }

    private func move(to indexPath: IndexPath, completion: (() -> Void)?) {
        unbind()
        interactionState = .disabled
        MoveAnimation(thumbnails: thumbnails, preview: preview, index: indexPath).run {
            self.interactionState = .enabled
            self.bind()
        }
    }

    private func beginScrolling() {
        interactionState = .disabled
        ScrollAnimation(thumbnails: thumbnails, preview: preview, state: .begin).run {}
    }

    private func endScrolling() {
        ScrollAnimation(thumbnails: thumbnails, preview: preview, state: .end).run {
            self.interactionState = .enabled
        }
    }
}

// MARK: - ScrollSynchronizer (UICollectionViewDelegate)

extension ScrollSynchronizer: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collection = scrollView as? UICollectionView else { return }
        unbind()
        if collection == preview.collectionView {
            let offset = scrollView.contentOffset.x
            let relativeOffset = offset / preview.itemSize.width / CGFloat(collection.numberOfItems(inSection: 0))
            thumbnails.changeOffset(relative: relativeOffset)
            activeIndex = thumbnails.nearestIndex
        }
        if scrollView == thumbnails.collectionView {
            debugPrint(thumbnails.relativeOffset)
            let index = thumbnails.nearestIndex
            if index != activeIndex {
                activeIndex = index
                let indexPath = IndexPath(row: activeIndex, section: 0)
                preview.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
        bind()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if activeIndex != indexPath.row {
            activeIndex = indexPath.row
            handle(event: .move(index: indexPath, completion: .none))
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == thumbnails.collectionView {
            handle(event: .beginScrolling)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == thumbnails.collectionView && !decelerate {
            thumbnailEndScrolling()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == thumbnails.collectionView {
            thumbnailEndScrolling()
        }
    }

    func thumbnailEndScrolling() {
        handle(event: .endScrolling)
    }
}

// MARK: - ScrollSynchronizer ()

extension ScrollSynchronizer {

    // MARK: - Event

    enum Event {

        // MARK: - Types

        case remove(index: IndexPath, dataSourceUpdate: () -> Void, completion: (() -> Void)?)
        case move(index: IndexPath, completion: (() -> Void)?)
        case beginScrolling
        case endScrolling
    }

    func handle(event: Event) {
        switch event {
        case .remove(let index, let update, let completion):
            delete(at: index, dataSourceUpdate: update, completion: completion)
        case .move(let index, let completion):
            move(to: index, completion: completion)
        case .endScrolling:
            endScrolling()
        case .beginScrolling:
            beginScrolling()
        }
    }
}

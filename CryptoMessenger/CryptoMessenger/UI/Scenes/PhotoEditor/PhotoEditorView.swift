import UIKit

// MARK: - PhotoEditorView

final class PhotoEditorView: UIView {

    // MARK: - Internal Properties

    var didTapShare: VoidBlock?
    var didTapBrush: VoidBlock?

    // MARK: - Private Properties

    private lazy var shareButton = UIButton()
    private lazy var brushButton = UIButton()
    private lazy var dateLabel = UILabel()
    var previewCollection: UICollectionView
    var thumbnailCollection: UICollectionView
    var synchronizer: ScrollSynchronizer

    // MARK: - Lifecycle

    init(frame: CGRect, sizeForIndex: ((Int) -> CGSize)?) {
        let previewLayout = PreviewLayout()
        let thumbnailLayout = ThumbnailLayout(dataSource: sizeForIndex)
        previewCollection = UICollectionView(frame: .zero, collectionViewLayout: previewLayout)
        thumbnailCollection = UICollectionView(frame: .zero, collectionViewLayout: thumbnailLayout)
        synchronizer = ScrollSynchronizer(
            preview: previewLayout,
            thumbnails: thumbnailLayout)
        super.init(frame: frame)
        addThumbnailCollection()
        addPreviewCollection()
        addShareButton()
        addBrushButton()
        addDateLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Private Methods

    @objc private func shareButtonAction() {
        didTapShare?()
    }

    @objc private func brushButtonAction() {
        didTapBrush?()
    }

    private func addPreviewCollection() {
        previewCollection.snap(parent: self) {
            $0.isPagingEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        } layout: {
            $0.top.leading.trailing.equalTo($1)
            $0.bottom.equalTo(self.thumbnailCollection.snp.top)
        }
    }

    func addThumbnailCollection() {
        thumbnailCollection.snap(parent: self) {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        } layout: {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-137)
            $0.leading.equalTo($1)
            $0.trailing.equalTo($1)
            $0.height.equalTo(48)
        }
    }

    private func addShareButton() {
        shareButton.snap(parent: self) {
            $0.setImage(R.image.photoEditor.share(), for: .normal)
            $0.contentMode = .scaleAspectFill
            $0.addTarget(self, action: #selector(self.shareButtonAction), for: .touchUpInside)
        } layout: {
            $0.leading.equalTo($1).offset(20)
            $0.bottom.equalTo($1).offset(-32)
            $0.width.height.equalTo(24)
        }
    }

    private func addBrushButton() {
        brushButton.snap(parent: self) {
            $0.setImage(R.image.callList.deleteimage(), for: .normal)
            $0.contentMode = .scaleAspectFill
            $0.addTarget(self, action: #selector(self.brushButtonAction), for: .touchUpInside)
        } layout: {
            $0.trailing.equalTo($1).offset(-16)
            $0.bottom.equalTo($1).offset(-32)
            $0.width.height.equalTo(24)
        }
    }

    private func addDateLabel() {
        dateLabel.snap(parent: self) {
            $0.titleAttributes(
                text: "27.05.20",
                [
                    .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center)),
                    .font(.semibold(15)),
                    .color(.white())
                ]
            )
            $0.lineBreakMode = .byWordWrapping
            $0.numberOfLines = 0
        } layout: {
            $0.centerX.equalTo($1)
            $0.bottom.equalTo($1).offset(-32)
        }
    }
}

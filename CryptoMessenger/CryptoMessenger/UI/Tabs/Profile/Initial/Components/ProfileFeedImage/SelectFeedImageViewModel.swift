import Foundation

protocol SelectFeedImageViewModelProtocol: ObservableObject {
    var displayItems: [SelectFeedImageType] { get }

    func onSourceTypeTap(type: UIImagePickerController.SourceType)
    func itemsHeight() -> CGFloat
}

final class SelectFeedImageViewModel {
    @Published var displayItems: [SelectFeedImageType] = SelectFeedImageType.allCases
    let sourceType: GenericBlock<UIImagePickerController.SourceType>

    init(
        sourceType: @escaping GenericBlock<UIImagePickerController.SourceType>
    ) {
        self.sourceType = sourceType
    }
}

// MARK: - SelectFeedImageViewModelProtocol

extension SelectFeedImageViewModel: SelectFeedImageViewModelProtocol {

    func onSourceTypeTap(type: UIImagePickerController.SourceType) {
        sourceType(type)
    }

    func itemsHeight() -> CGFloat {
        CGFloat(displayItems.count * 60) + 20
    }
}

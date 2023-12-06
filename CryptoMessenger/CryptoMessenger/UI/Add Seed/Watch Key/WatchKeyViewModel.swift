import Foundation

protocol WatchKeyViewModelDelegate {
    func didFinishShowPhrase()
}

protocol WatchKeyViewModelProtocol: ObservableObject {
    var createButtonOpacity: CGFloat { get set }
    var isCreateButtonHidden: Bool { get set }
    var isSnackbarPresented: Bool { get set }
    var generatedKey: String { get }
    var resources: WatchKeyResourcable.Type { get }
    var type: WatchKeyViewType { get }

    func onCopyKeyTap()
    func onCloseTap()
}

final class WatchKeyViewModel {

    @Published var createButtonOpacity: CGFloat = 1.0
    @Published var isCreateButtonHidden = false
    @Published var isSnackbarPresented = false
    @Published var generatedKey: String
    let resources: WatchKeyResourcable.Type
    let coordinator: WatchKeyViewModelDelegate
    let type: WatchKeyViewType
    let pasteboardService: PasteboardServiceProtocol

    init (
        generatedKey: String,
        coordinator: WatchKeyViewModelDelegate,
        type: WatchKeyViewType = .showSeed,
        pasteboardService: PasteboardServiceProtocol = PasteboardService.shared,
        resources: WatchKeyResourcable.Type = WatchKeyResources.self
    ) {
        self.generatedKey = generatedKey
        self.coordinator = coordinator
        self.type = type
        self.pasteboardService = pasteboardService
        self.resources = resources
    }
}

// MARK: - WatchKeyViewModelProtocol

extension WatchKeyViewModel: WatchKeyViewModelProtocol {
    func onCopyKeyTap() {
        pasteboardService.copyToPasteboard(text: generatedKey)
        isSnackbarPresented = true
        delay(2) { [weak self] in
            self?.isSnackbarPresented = false
        }
    }

    func onCloseTap() {
        coordinator.didFinishShowPhrase()
    }
}

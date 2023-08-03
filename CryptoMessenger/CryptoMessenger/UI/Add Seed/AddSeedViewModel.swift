import Foundation

protocol AddSeedViewModelProtocol: ObservableObject {
    func onImportKeyTap()
}

final class AddSeedViewModel {
    var coordinator: AddSeedCoordinatable?
}

// MARK: - AddSeedViewModelProtocol

extension AddSeedViewModel: AddSeedViewModelProtocol {
    func onImportKeyTap() {
        coordinator?.showImportKey()
    }
}

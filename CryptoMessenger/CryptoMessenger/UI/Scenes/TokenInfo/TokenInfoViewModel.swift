import Combine
import SwiftUI

// MARK: - TokenInfoViewModel

final class TokenInfoViewModel: ObservableObject {

    // MARK: - Internal Properties

    @State var address: String

    // MARK: - Private Properties

    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

    // MARK: - Lifecycle

    init(address: String) {
        self.address = address
    }

    // MARK: - Internal Methods

    // MARK: - Private Methods

    private func updateData() {
    }
}

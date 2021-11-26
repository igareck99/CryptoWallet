import SwiftUI

// MARK: - SessionViewModel

class SessionViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var listData = SessionItem.sessions()

}

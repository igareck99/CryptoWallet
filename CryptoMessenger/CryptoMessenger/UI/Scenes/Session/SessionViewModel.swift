import SwiftUI

// MARK: - SessionViewModel

class SessionViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: SessionSceneDelegate?

    @Published var listData = SessionItem.sessions()

}

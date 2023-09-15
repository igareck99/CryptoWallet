import SwiftUI

// MARK: - AudioEventItem

struct AudioEventItem: Identifiable, ViewGeneratable {
    
    // MARK: - Internal Properties
    
    let id = UUID()
    let shortDate: String
    let messageId: String
    let isCurrentUser: Bool
    let isFromCurrentUser: Bool
    let audioDuration: String
    let url: URL
    let reactions: any ViewGeneratable
    let eventData: any ViewGeneratable

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        let viewModel = AudioMessageViewModel(url: url, messageId: messageId)
        return AudioEventView(viewModel: viewModel,
                              data: self,
                              eventData: eventData.view(),
                              reactions: reactions.view()).anyView()
    }
}

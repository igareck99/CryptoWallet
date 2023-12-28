import SwiftUI

// MARK: - ChannelParticipantsRouterStatable

protocol ChannelParticipantsRouterStatable: ObservableObject {
    var path: NavigationPath { get set }
    func update(path: Binding<NavigationPath>)
}

final class ChannelParticipantsRouterState: ChannelParticipantsRouterStatable {

    @Binding var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    func update(path: Binding<NavigationPath>) {
        _path = path
    }
}

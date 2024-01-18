import Foundation
import SwiftUI

struct ChannelParticipantsRouter<
    Content: View,
    State: ChannelParticipantsRouterStatable,
    Factory: ViewsBaseFactoryProtocol
>: View {

    @ObservedObject var state: State
    let factory: Factory.Type
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .navigationDestination(
                    for: BaseContentLink.self,
                    destination: factory.makeContent
                )
        }
    }
}

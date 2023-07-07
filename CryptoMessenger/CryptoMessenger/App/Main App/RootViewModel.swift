import Combine
import SwiftUI

protocol RootViewAppModelable: ObservableObject {
    var rootView: any View { get }
}

protocol RootViewModelable: ObservableObject {
    var state: RootViewState { get set }
}

enum RootViewState {
    case content1
    case content2
}

final class RootViewModel: RootViewAppModelable, RootViewModelable {

    @Published var rootView: any View
    @Published var state: RootViewState
    private var statePublisher: Published<RootViewState>.Publisher { $state }
    private var cansellable = Set<AnyCancellable>()

    init() {
        self.state = .content1
        self.rootView = Text("")
        self.setUpBindings()
    }

    func setUpBindings() {
        statePublisher.sink { [weak self] flag in
            guard let self = self else { return }
            if flag == .content2 {
                self.rootView = ContentView2(viewModel: self)
            } else {
                self.rootView = ContentView1(viewModel: self)
            }
        }.store(in: &cansellable)
    }
}

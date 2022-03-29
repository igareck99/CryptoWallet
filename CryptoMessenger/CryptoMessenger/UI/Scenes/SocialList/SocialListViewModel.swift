import SwiftUI
import Combine

// MARK: - SocialListViewModel

final class SocialListViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: SocialListSceneDelegate?
    @Published var listData: [SocialListItem] = []

    // MARK: - Private Properties

    @Published private(set) var state: SocialListFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<SocialListFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SocialListFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private(set) var mxStore: MatrixStore

    // MARK: - Lifecycle

    init() {
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: SocialListFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Internal Methods

    func onMove(source: IndexSet, destination: Int) {
        listData.move(fromOffsets: source, toOffset: destination)
    }

    func remove(offsets: IndexSet) {
        listData.remove(atOffsets: offsets)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                }
            }
            .store(in: &subscriptions)

        mxStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateData() {
        listData.append(SocialListItem(url: "instagram",
                                       sortOrder: 1,
                                       socialType: .instagram))
        listData.append(SocialListItem(url: "twitter",
                                       sortOrder: 4,
                                       socialType: .twitter))
        listData.append(SocialListItem(url: "facebook",
                                       sortOrder: 2,
                                       socialType: .facebook))
//        listData.append(SocialListItem(url: "vk",
//                                       sortOrder: 3,
//                                       socialType: .vk))
        listData.append(SocialListItem(url: "linkedin",
                                       sortOrder: 4,
                                       socialType: .linkedin))
//        listData.append(SocialListItem(url: "tiktok",
//                                       sortOrder: 5,
//                                       socialType: .tiktok))
        listData.sorted { item1, item2 in
            item1.sortOrder < item2.sortOrder
        }

    }
}

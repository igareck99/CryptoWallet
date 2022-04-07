import SwiftUI
import Combine

// MARK: - SocialListViewModel

final class SocialListViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: SocialListSceneDelegate?
    @Published var listData: [SocialListItem] = [
        SocialListItem(url: "",
                       sortOrder: 1,
                       socialType: .instagram),
        SocialListItem(url: "",
                       sortOrder: 2,
                       socialType: .facebook),
        SocialListItem(url: "",
                       sortOrder: 3,
                       socialType: .twitter),
        SocialListItem(url: "",
                       sortOrder: 4,
                       socialType: .vk),
        SocialListItem(url: "",
                       sortOrder: 5,
                       socialType: .tiktok),
        SocialListItem(url: "",
                       sortOrder: 6,
                       socialType: .linkedin)
    ]

    // MARK: - Private Properties

    @Published private(set) var state: SocialListFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<SocialListFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SocialListFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var apiClient: APIClientManager

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

    func updateListData(item: SocialListItem) {
        listData = listData.filter { $0.socialType != item.socialType }
        listData.append(item)
        listData = listData.sorted(by: { $0.sortOrder < $1.sortOrder })
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

    private func getSocialList() {
        apiClient.publisher(Endpoints.Social.getSocial(mxStore.getUserId()))
            .replaceError(with: [])
            .sink { [weak self] response in
                for x in response {
                    let newList = self?.listData.filter { $0.socialType.description != x.socialType } ?? []
                    if newList.count != self?.listData.count {
                        self?.listData = newList
                        self?.listData.append(SocialListItem(url: x.url,
                                                             sortOrder: x.sortOrder,
                                                             socialType: SocialNetworkType.networkType(item: x.socialType)))
                    }
                }
                guard let sortedList = self?.listData.sorted(by: { $0.sortOrder < $1.sortOrder }) else { return }
                self?.listData = sortedList
            }
            .store(in: &subscriptions)
    }

    func addSocial(data: [SocialListItem]) {
        var testList: [SocialResponse] = []
        for x in data {
            testList.append(SocialResponse(sortOrder: x.sortOrder,
                                           socialType: x.socialType.description,
                                           url: x.url))
        }
        apiClient.publisher(Endpoints.Social.setSocialNew(testList,
                                                          user: mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                default:
                    break
                }
            }, receiveValue: { [weak self] _ in
                
            })
            .store(in: &subscriptions)
    }

    private func updateData() {
        getSocialList()
    }
}

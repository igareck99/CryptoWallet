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

	@Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
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
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func getSocialList() {
        apiClient.publisher(Endpoints.Social.getSocial(matrixUseCase.getUserId()))
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
            var updatedUrl = x.url
            if !x.url.isEmpty {
                switch x.socialType {
                case .twitter:
                    if !x.url.contains("https://twitter.com/") || !x.url.contains("twitter.com/") {
                        updatedUrl = "https://twitter.com" + x.url
                    }
                case .facebook:
                    if !x.url.contains("https://www.facebook.com/") || !x.url.contains("www.facebook.com/") {
                        updatedUrl = "https://www.facebook.com/" + x.url
                    }
                case .vk:
                    if !x.url.contains("https://vk.com/") || !x.url.contains("vk.com/") {
                        updatedUrl = "https://vk.com/" + x.url
                    }
                case .instagram:
                    if !x.url.contains("https://instagram.com/") || !x.url.contains("instagram.com/") {
                        updatedUrl = "https://instagram.com/" + x.url
                    }
                case .linkedin:
                    if !x.url.contains("https://www.linkedin.com/") || !x.url.contains("www.linkedin.com/") {
                        updatedUrl = "www.linkedin.com/" + x.url
                    }
                case .tiktok:
                    if !x.url.contains("https://www.tiktok.com/") || !x.url.contains("www.tiktok.com/") {
                        updatedUrl = "https://www.tiktok.com/" + x.url
                    }
                }
            }
            testList.append(SocialResponse(sortOrder: x.sortOrder,
                                           socialType: x.socialType.description,
                                           url: updatedUrl))
        }
        apiClient.publisher(Endpoints.Social.setSocialNew(testList,
                                                          user: matrixUseCase.getUserId()))
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

import Combine
import SwiftUI

// MARK: - SocialListViewModel

final class SocialListViewModel: ObservableObject {

    // MARK: - Internal Properties

	let resources: SocialListResourcesable
    @Published var listData = [SocialListItem]()
    @Published var dragging: SocialListItem?

    // MARK: - Private Properties

    @Published private(set) var state: SocialListFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<SocialListFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SocialListFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let typesOrder: [(order: Int, type: SocialNetworkType)] = [
        (1, .instagram), (2, .facebook), (3, .twitter),
        (4, .vk), (5, .tiktok), (6, .linkedin)
    ]
    private let emptyData: [SocialListItem] = [.init(sortOrder: 1, socialType: .instagram),
                                               .init(sortOrder: 2, socialType: .vk),
                                               .init(sortOrder: 3, socialType: .twitter),
                                               .init(sortOrder: 4, socialType: .facebook),
                                               .init(sortOrder: 5, socialType: .linkedin),
                                               .init(sortOrder: 6, socialType: .tiktok)]


	@Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    @Injectable private var apiClient: APIClientManager

    // MARK: - Lifecycle

	init(
		resources: SocialListResourcesable = SocialListResources()
	) {
		self.resources = resources
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
        guard let startIndex = source.first else { return }
        listData.move(fromOffsets: source, toOffset: destination)
        let startElement = listData[startIndex]
        listData = listData.map {
            var value = 0
            if $0.sortOrder == startIndex + 1 {
                value = destination
            } else if $0.sortOrder == destination {
                value = destination - 1
            } else {
                value = (listData.firstIndex(of: $0) ?? 0) + 1
            }
            return SocialListItem(url: $0.url,
                                  sortOrder: value,
                                  socialType: $0.socialType)
        }
    }

	func socialNetworkDidSubmitted(item: SocialListItem) {
		updateListData(item: item, isEditing: false)
	}

	func socialNetworkDidEdited(item: SocialListItem, isEditing: Bool) {
		updateListData(item: item, isEditing: false)
	}

	private func updateListData(item: SocialListItem, isEditing: Bool) {
		guard !isEditing else { return }
		let result = listData.enumerated().first { $0.1.socialType == item.socialType }
		guard let model = result, listData.indices.contains(model.offset) else { return }
		listData[model.offset] = item
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
				guard let self = self else { return }
				let remoteTypes = response.reduce(into: [SocialNetworkType: SocialListItem](), {
					let socialType = SocialNetworkType.networkType(item: $1.socialType)
					let item = SocialListItem(url: $1.url, sortOrder: $1.sortOrder, socialType: socialType)
					$0[socialType] = item
				})
                var result = remoteTypes.map {
                    return $0.value
                }
                result = result.sorted(by: { $0.sortOrder < $1.sortOrder })
                if result.isEmpty {
                    self.listData = self.emptyData
                } else {
                    self.listData = result
                }
            }
            .store(in: &subscriptions)
    }

	func saveSocialData() {
		addSocial(data: listData)
	}

    private func addSocial(data: [SocialListItem]) {
		let newList: [SocialResponse] = data
			.filter { validateURL(for: $0.socialType, url: $0.url) }
			.map {
				SocialResponse(
					sortOrder: $0.sortOrder,
					socialType: $0.socialType.description,
					url: $0.url
				)
		}
        apiClient.publisher(Endpoints.Social.setSocialNew(newList,
                                                          user: matrixUseCase.getUserId()))
            .sink(receiveCompletion: { completion in
				guard case .failure = completion else { return }
				debugPrint("SocialListViewModel setSocialNew: FAILURE")
			}, receiveValue: {
				debugPrint("SocialListViewModel setSocialNew: SUCCESS")
				debugPrint("SocialListViewModel setSocialNew: SOCIAL_LIST: \($0)")
			})
            .store(in: &subscriptions)
    }

	private func validateURL(for socialType: SocialNetworkType, url: String) -> Bool {
		guard let baseUrl = SocialNetworkType.baseUrlsByType[socialType] else { return false }
		let urlString: String = url.lowercased().contains(socialType.description.lowercased()) ? url : baseUrl + url
		return URL(string: urlString) != nil
	}

    private func updateData() {
        getSocialList()
    }
}

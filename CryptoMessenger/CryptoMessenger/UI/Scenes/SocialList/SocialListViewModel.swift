import Combine
import SwiftUI

// MARK: - SocialListViewModel

final class SocialListViewModel: ObservableObject {

    // MARK: - Internal Properties

	let resources: SocialListResourcesable
    weak var delegate: SocialListSceneDelegate?
    @Published var listData = [SocialListItem]()
	private let typesOrder: [(order: Int, type: SocialNetworkType)] = [
		(1, .instagram), (2, .facebook), (3, .twitter),
		(4, .vk), (5, .tiktok), (6, .linkedin)
	]

    // MARK: - Private Properties

    @Published private(set) var state: SocialListFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<SocialListFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SocialListFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

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
        listData.move(fromOffsets: source, toOffset: destination)
    }

    func remove(offsets: IndexSet) {
        listData.remove(atOffsets: offsets)
    }

	func socialNetworkDidSubmitted(item: SocialListItem) {
		updateListData(item: item, isEditing: false)
	}

	func socialNetworkDidEdited(item: SocialListItem, isEditing: Bool) {
		updateListData(item: item, isEditing: isEditing)
	}

	private func updateListData(item: SocialListItem, isEditing: Bool) {
		debugPrint("SocialListItemView SocialListViewModel updateListData_1: \(isEditing)")
		guard !isEditing else { return }
		debugPrint("SocialListItemView SocialListViewModel updateListData_2: \(isEditing)")
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

				let result: [SocialListItem] = self.typesOrder.map { model in
					if let item = remoteTypes[model.type] { return item }
					return SocialListItem(sortOrder: model.order, socialType: model.type)
				}
				self.listData = result
            }
            .store(in: &subscriptions)
    }

	func saveSocialData() {
		addSocial(data: listData)
	}

    private func addSocial(data: [SocialListItem]) {
		debugPrint("SocialListItemView SocialListViewModel addSocial: \(data)")
		let testList: [SocialResponse] = data
			.filter { validateURL(for: $0.socialType, url: $0.url) }
			.map {
				SocialResponse(
					sortOrder: $0.sortOrder,
					socialType: $0.socialType.description,
					url: $0.url
				)
		}

        apiClient.publisher(Endpoints.Social.setSocialNew(testList,
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

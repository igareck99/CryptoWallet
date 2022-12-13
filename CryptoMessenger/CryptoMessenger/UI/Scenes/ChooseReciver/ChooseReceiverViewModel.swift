import Combine
import SwiftUI

final class ChooseReceiverViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChooseReceiverSceneDelegate?
    @Published var userIds: [String] = []
    @Published var userPhones: [String] = []
    @Published private(set) var contacts: [Contact] = []
    @Published var contactViewModel = SelectContactViewModel(mode: .add)
    @Published var userWalletsData: [UserWallletData] = []
    @Published var userTelephoneData: [UserWallletData] = []

    // MARK: - Private Properties

    @Published private(set) var state: ChooseReceiverFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ChooseReceiverFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChooseReceiverFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userSettings: UserFlowsStorage & UserCredentialsStorage
    @Injectable private var apiClient: APIClientManager
    @Injectable private var contactsStore: ContactsManager
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol

    // MARK: - Lifecycle

    init(
		userSettings: UserFlowsStorage & UserCredentialsStorage
	) {
		self.userSettings = userSettings
        contactViewModel.send(.onAppear)
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: ChooseReceiverFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case let .onScanner(scannedScreen):
                    self?.delegate?.handleNextScene(.scanner(scannedScreen))
                }
            }
            .store(in: &subscriptions)
        contactViewModel.$existingContacts
            .receive(on: DispatchQueue.main)
            .sink { [self] users in
                if !users.isEmpty {
                    checkUserWallet(users)
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
    
    private func getUserData(_ user: String, completion: @escaping (String?) -> Void) {
        self.apiClient.publisher(Endpoints.Users.getProfile(user))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    debugPrint("Error in Get user data Api  \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let phone = response["phone"] as? String else {  return }
                completion(phone)
            }
            .store(in: &subscriptions)
    }
    
    private func checkUserWallet(_ id: [Contact]) {
        for item in id {
            self.apiClient.publisher(Endpoints.Wallet.getAssetsByUserName(item.mxId))
                .sink { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        debugPrint("Error in checkUserWallet  \(error)")
                    default:
                        break
                    }
                } receiveValue: { [weak self] response in
                    self?.getUserData(item.mxId) { value in
                        guard let btc = response[item.mxId]?["bitcoin"]?["address"] else { return }
                        guard let eth = response[item.mxId]?["bitcoin"]?["address"] else { return }
                        if !btc.isEmpty && !eth.isEmpty {
                            self?.userWalletsData.append(UserWallletData(name: item.name,
                                                                         bitcoin: response[item.mxId]?["bitcoin"]?["address"] ?? "",
                                                                         ethereum: response[item.mxId]?["ethereum"]?["address"] ?? "",
                                                                         url: item.avatar,
                                                                         phone: value ?? ""))
                        }
                    }
                }
                .store(in: &subscriptions)
        }
    }
}

// MARK: - SearchType

enum SearchType {

    // MARK: - Types

    case telephone
    case wallet

    // MARK: - Internal Properties

    var result: String {
        switch self {
        case .telephone:
            return R.string.localizable.chooseReceiverTelephone()
        case .wallet:
            return R.string.localizable.chooseReceiverWallet()
        }
    }
}

// MARK: - UserWallletData

struct UserWallletData: Hashable {

    let name: String
    let bitcoin: String
    let ethereum: String
    let url: URL?
    let phone: String
}

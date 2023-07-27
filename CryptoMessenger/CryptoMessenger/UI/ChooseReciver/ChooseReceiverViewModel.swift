import Combine
import SwiftUI
import MatrixSDK

protocol ChooseReceiverViewCoordinatable {
    
}

final class ChooseReceiverViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ChooseReceiverSceneDelegate?
    private let coordinator: ChooseReceiverViewCoordinatable
    @Published private(set) var contacts: [Contact] = []
    @Published var contactViewModel = SelectContactViewModel(mode: .add)
    @Published var userWalletsData: [UserWallletData] = []
    @Published var userWalletsFilteredData: [UserWallletData] = []
    @Published var searchType = SearchType.telephone
    var isEnterAdressView = false
    let resources: ChooseReciverSourcable.Type = ChooseReciverSources.self

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
        coordinator: ChooseReceiverViewCoordinatable,
        userSettings: UserFlowsStorage & UserCredentialsStorage = UserDefaultsService.shared,
        resources: ChooseReciverSourcable.Type = ChooseReciverSources.self
	) {
        self.coordinator = coordinator
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
    
    func getAdress(_ user: UserWallletData, _ receiver: UserReceiverData) -> String {
        switch receiver.walletType {
        case .ethereum, .ethereumUSDC, .ethereumUSDT:
            return user.ethereum
        case .bitcoin:
            return user.bitcoin
        case .binance, .binanceBUSD, .binanceUSDT:
            return user.binance
        default:
            return ""
        }
    }

    func updateText(_ text: String) {
        if !text.isEmpty {
            if searchType == .telephone {
                userWalletsFilteredData = userWalletsData.filter({ $0.phone.contains(text) })
            } else {
                userWalletsFilteredData = userWalletsData.filter({ $0.ethereum.contains(text) })
                if userWalletsFilteredData.isEmpty {
                    let data = UserWallletData(
                        name: "По адресу",
                        bitcoin: text,
                        ethereum: text,
                        binance: text,
                        url: nil,
                        phone: ""
                    )
                    userWalletsFilteredData.append(data)
                }
            }
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                    case let .onScanner(scannedScreen):
                        debugPrint("scannedScreen: \(scannedScreen)")
//                    self?.delegate?.handleNextScene(.scanner(scannedScreen))
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

    private func getUserData(_ user: String, completion: @escaping (String?, String?) -> Void) {
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
                guard let username = response["user_id"] as? String else {  return }
                completion(phone, username)
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
                    self?.getUserData(item.mxId) { phone, name in
                        guard let btc = response[item.mxId]?["bitcoin"]?["address"] else { return }
                        guard let eth = response[item.mxId]?["ethereum"]?["address"] else { return }
                        guard let binance = response[item.mxId]?["binance"]?["address"] else { return }
                        if !btc.isEmpty && !eth.isEmpty {
                            self?.userWalletsData.append(UserWallletData(name: name ?? item.name,
                                                                         bitcoin: btc,
                                                                         ethereum: eth,
                                                                         binance: binance,
                                                                         url: item.avatar,
                                                                         phone: phone ?? ""))
                        }
                    }
                }
                .store(in: &subscriptions)
        }
    }
}

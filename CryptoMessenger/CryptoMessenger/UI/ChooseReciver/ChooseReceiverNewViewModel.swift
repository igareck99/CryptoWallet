import Combine
import SwiftUI

// MARK: - ChooseReceiverViewModelProtocol

protocol ChooseReceiverViewModelProtocol: ObservableObject {
    var searchText: String { get set }
    
    var scannedText: String { get set }
    
    var isSnackbarPresented: Bool { get set }
    
    var messageText: String { get set }

    func send(_ event: ChooseReceiverFlow.Event)

    var resources: ChooseReciverSourcable.Type { get }

    var searchType: SearchType { get set }
    
    var userWalletsViews: [any ViewGeneratable] { get }
    
    func onScanner(_ text: Binding<String>)
}

// MARK: - ChooseReceiverNewViewModel

final class ChooseReceiverNewViewModel: ObservableObject, ChooseReceiverViewModelProtocol {

    // MARK: - Internal Properties

    @Published var searchText = ""
    @Published var scannedText = ""
    @Published var messageText = ""
    @Published var isSnackbarPresented = false
    @Published var searchType = SearchType.telephone
    @Published var contacts: [Contact] = []
    @Published var userWalletsData: [UserWallletData] = []
    @Published var userWalletsViews: [any ViewGeneratable] = []
    @Binding var receiverData: UserReceiverData
    let resources: ChooseReciverSourcable.Type = ChooseReciverSources.self
    var coordinator: TransferViewCoordinatable

    // MARK: - Private Properties

    @Published private(set) var state: ChooseReceiverFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ChooseReceiverFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChooseReceiverFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let contactsUseCase: ContactsUseCaseProtocol
    @Injectable private var apiClient: APIClientManager

    // MARK: - Lifecycle

    init(receiverData: Binding<UserReceiverData>,
         coordinator: TransferViewCoordinatable,
         contactsUseCase: ContactsUseCaseProtocol = ContactsUseCase.shared) {
        self._receiverData = receiverData
        self.coordinator = coordinator
        self.contactsUseCase = contactsUseCase
        bindInput()
        bindInput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: ChooseReceiverFlow.Event) {
        eventSubject.send(event)
    }
    
    func onScanner(_ text: Binding<String>) {
        self.coordinator.showAdressScanner(text)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.syncContacts()
                }
            }
            .store(in: &subscriptions)
        $searchText
            .receive(on: DispatchQueue.main)
            .sink { [self] value in
                if !value.isEmpty {
                    var result: [UserWallletData] = []
                    switch self.searchType {
                    case .wallet:
                        switch self.receiverData.walletType {
                        case .bitcoin:
                            result = self.userWalletsData.compactMap {
                                if $0.bitcoin.contains(value) {
                                    return $0
                                }
                                return nil
                            }
                        case .ethereum:
                            result = self.userWalletsData.compactMap {
                                if $0.ethereum.contains(value) {
                                    return $0
                                }
                                return nil
                            }
                        case .binance:
                            result = self.userWalletsData.compactMap {
                                if $0.binance.contains(value) {
                                    return $0
                                }
                                return nil
                            }
                        default:
                            break
                        }
                        result = result.map {
                            let data = UserWallletData(name: $0.name,
                                                       bitcoin: $0.bitcoin,
                                                       ethereum: $0.ethereum,
                                                       binance: $0.binance,
                                                       url: $0.url,
                                                       phone: $0.phone,
                                                       searchType: searchType,
                                                       walletType: self.receiverData.walletType) { value in
                                self.setAdress(value)
                            }
                            return data
                        }
                        self.userWalletsViews = result
                    case .telephone:
                        var result = self.userWalletsData.filter({ $0.phone.contains(value) })
                        result = result.map {
                            let data = UserWallletData(name: $0.name,
                                                       bitcoin: $0.bitcoin,
                                                       ethereum: $0.ethereum,
                                                       binance: $0.binance,
                                                       url: $0.url,
                                                       phone: $0.phone,
                                                       searchType: searchType,
                                                       walletType: self.receiverData.walletType) { value in
                                self.setAdress(value)
                            }
                            return data
                        }
                        self.userWalletsViews = result
                        self.objectWillChange.send()
                    }
                } else {
                    self.searchType = self.searchType
                }
            }
            .store(in: &subscriptions)
        $scannedText
            .receive(on: DispatchQueue.main)
            .sink { [self] value in
                self.searchText = value
                self.receiverData.adress = value
                // TODO: - Сделать ячейку для введенного текста
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        $searchType
            .receive(on: DispatchQueue.main)
            .sink { [self] value in
                var result: [UserWallletData] = []
                result = self.userWalletsData.map {
                    let data = UserWallletData(name: $0.name,
                                               bitcoin: $0.bitcoin,
                                               ethereum: $0.ethereum,
                                               binance: $0.binance,
                                               url: $0.url,
                                               phone: $0.phone,
                                               searchType: value,
                                               walletType: self.receiverData.walletType) { value in
                        self.setAdress(value)
                    }
                    return data
                }
                self.userWalletsViews = result
            }
            .store(in: &subscriptions)
    }

    private func setAdress(_ value: UserWallletData) {
        switch receiverData.walletType {
        case .bitcoin:
            self.receiverData.adress = value.bitcoin
        case .ethereum:
            self.receiverData.adress = value.ethereum
        case .binance:
            self.receiverData.adress = value.binance
        default:
            break
        }
        coordinator.previousScreen()
    }
    
    func showSnackBar(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.messageText = text
            self?.isSnackbarPresented = true
            self?.objectWillChange.send()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.messageText = ""
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
    
    private func syncContacts() {
        contactsUseCase.syncContacts { state in
            switch state {
            case .allowed:
                self.contactsUseCase.reuqestUserContacts { contact in
                    self.contactsUseCase.matchServerContacts(contact, .groupCreate) { result in
                        self.contacts = result.filter({ $0.type == .lastUsers || $0.type == .existing  })
                        print("slsalasas  \(self.contacts)")
                        self.checkUserWallet(self.contacts)
                    } onTap: { _ in
                    }
                }
                return
            case .notDetermined:
                self.contactsUseCase.requestContactsAccess { isAllowed in
                    if isAllowed {
                        self.contactsUseCase.reuqestUserContacts { contact in
                            self.contactsUseCase.matchServerContacts(contact, .groupCreate) { result in
                                self.contacts = result.filter({ $0.type == .lastUsers })
                                self.checkUserWallet(self.contacts)
                            } onTap: { _ in
                            }
                        }
                    }
                }
                return
            case .restricted, .denied, .unknown:
                break
            }
        }
    }

    private func getUserData(_ user: String, completion: @escaping (String?, String?) -> Void) {
        self.apiClient.publisher(Endpoints.Users.getProfile(user))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.showSnackBar(text: "Ошибка загрузки профиля")
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
                        self?.showSnackBar(text: "Ошибка загрузки кошелька")
                        debugPrint("Error in checkUserWallet  \(error)")
                    default:
                        break
                    }
                } receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.getUserData(item.mxId) { phone, name in
                        guard let btc = response[item.mxId]?["bitcoin"]?["address"] else { return }
                        guard let eth = response[item.mxId]?["ethereum"]?["address"] else { return }
                        guard let binance = response[item.mxId]?["binance"]?["address"] else { return }
                        if !btc.isEmpty && !eth.isEmpty {
                            self.userWalletsData.append(UserWallletData(name: name ?? item.name,
                                                                        bitcoin: btc,
                                                                        ethereum: eth,
                                                                        binance: binance,
                                                                        url: item.avatar,
                                                                        phone: phone ?? "",
                                                                        walletType: self.receiverData.walletType,
                                                                        onTap: { value in
                                self.setAdress(value)
                            }))
                            self.userWalletsViews = self.userWalletsData
                        }
                        
                    }
                }
                .store(in: &subscriptions)
        }
    }
}

import Combine
import SwiftUI

// MARK: - WalletNewViewModel

final class WalletNewViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: WalletNewSceneDelegate?
    @Published var totalBalance = ""
    @Published var transactionList: [TransactionInfo] = []
    @Published var cardsList: [WalletInfo] = [
        .init(
            walletType: .ethereum,
            address: "0xty9 ... Bx9M",
            coinAmount: 1.012,
            fiatAmount: 33
        ),
        .init(  
            walletType: .aur,
            address: "0xj3 ... 138f",
            coinAmount: 2.3042,
            fiatAmount: 18.1342
        ),
        .init(
            walletType: .aur,
            address: "0xj3 ... 148f",
            coinAmount: 2.3042,
            fiatAmount: 18.1342
        )
    ]
    @Published var canceledImage = UIImage()

    // MARK: - Private Properties

    @Published private(set) var state: WalletNewFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<WalletNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<WalletNewFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

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

    func send(_ event: WalletNewFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case let .onTransactionAddress(selectorTokenIndex, address):
                    self?.delegate?.handleNextScene(.transaction(0, selectorTokenIndex, address))
                case let .onTransactionType(selectorFilterIndex):
                    self?.delegate?.handleNextScene(.transaction(selectorFilterIndex, 0, ""))
                case let .onTransactionToken(selectorTokenIndex):
                    self?.delegate?.handleNextScene(.transaction(0, selectorTokenIndex, ""))
                case let .onImportKey:
                    self?.delegate?.handleNextScene(.importKey)
                case .onTransfer:
                    self?.delegate?.handleNextScene(.transfer)
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
        totalBalance = "$12 5131.53"
        transactionList = []
        canceledImage = UIImage(systemName: "exclamationmark.circle")?
            .withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage()
        transactionList.append(TransactionInfo(type: .send,
                                               date: "Sep 09",
                                               from: "0xty9 ... Bx9M",
                                               fiatValue: "15.53$",
                                               transactionCoin: .ethereum,
                                               amount: -0.0236))
        transactionList.append(TransactionInfo(type: .receive,
                                               date: "Sep 09",
                                               from: "0xty9 ... Bx9M",
                                               fiatValue: "15.53$",
                                               transactionCoin: .ethereum,
                                               amount: 1.12))
        transactionList.append(TransactionInfo(type: .receive,
                                               date: "Sep 08",
                                               from: "0xj3 ... 138f",
                                               fiatValue: "15.53$",
                                               transactionCoin: .aur,
                                               amount: 1.55))
        transactionList.append(TransactionInfo(type: .send,
                                               date: "Sep 07",
                                               from: "0xj3 ... 138f",
                                               fiatValue: "15.53$",
                                               transactionCoin: .aur,
                                               amount: 33))
        transactionList.append(TransactionInfo(type: .send,
                                               date: "Sep 07",
                                               from: "0xj3 ... 148f",
                                               fiatValue: "15.53$",
                                               transactionCoin: .aur,
                                               amount: 33))
    }
}

// MARK: - TransactionType

enum TransactionType {

    case send
    case receive
}

// MARK: - WalletType

enum WalletType {

    case ethereum
    case bitcoin
    case aur

    // MARK: - Internal Properties

    var result: String {
        switch self {
        case .ethereum:
            return R.string.localizable.transactionETHFilter()
        case .aur:
            return R.string.localizable.transactionAURFilter()
        case .bitcoin:
            return "BTC"
        }
    }

    var chooseTitle: String {
        switch self {
        case .ethereum:
            return R.string.localizable.transactionETHFilter()
        case .aur:
            return R.string.localizable.transactionAURFilter()
        case .bitcoin:
            return "BTC (Bitcoin)"
        }
    }

    var abbreviatedName: String {
        switch self {
        case .ethereum:
            return "ETH"
        case .aur:
            return "AUR"
        case .bitcoin:
            return "BTC"
        }
    }
}

// MARK: - TransactionInfo

struct TransactionInfo: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
    var type: TransactionType
    var date: String
    var from: String
    var fiatValue: String
    var transactionCoin: WalletType
    var amount: Double
    var isTapped = false
}

// MARK: - WalletInfo

struct WalletInfo: Identifiable, Equatable {

    // MARK: - Internal Properties

    let id = UUID()
    var walletType: WalletType
    var address: String
    var coinAmount: Double
    var fiatAmount: Double

    var result: (image: Image, fiatAmount: Double, currency: String) {
        switch walletType {
        case .ethereum:
            return (R.image.wallet.ethereumCard.image,
                    coinAmount * 153.5,
                    currency: "ETH")
        case .aur:
            return (R.image.wallet.card.image,
                    coinAmount * 13.2,
                    currency: "AUR")
        case .bitcoin:
            return (R.image.wallet.card.image,
                    coinAmount * 14334.43,
                    currency: "BTC")
        }
    }
}

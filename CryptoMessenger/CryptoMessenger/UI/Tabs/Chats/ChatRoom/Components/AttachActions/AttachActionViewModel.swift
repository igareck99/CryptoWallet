// swiftlint:disable all
import Combine
import SwiftUI
import Photos

// MARK: - AttachActionViewModel

final class AttachActionViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var isTransactionAvailable = false
    @Published var images: [UIImage] = []
    @Published var actions = [ActionItem]()
    let isDirectChat: Bool
    var tappedAction: (AttachAction) -> Void
    var onCamera: () -> Void
    var onSendPhoto: (UIImage) -> Void
    var cancellables = Set<AnyCancellable>()

    // MARK: - Private Properties

    @Injectable private(set) var togglesFacade: MainFlowTogglesFacade
    let apiClient: APIClientManager
    let matrixUseCase: MatrixUseCaseProtocol
    let coreDataService: CoreDataServiceProtocol
    var interlocutorId: String?
    var receiverWalletData: UserWallletData? = nil

    // MARK: - Lifecycle

    init(
        apiClient: APIClientManager = APIClient.shared,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        coreDataService: CoreDataServiceProtocol = CoreDataService.shared,
        interlocutorId: String? = nil,
        isDirectChat: Bool,
        tappedAction: @escaping (AttachAction) -> Void,
        onCamera: @escaping () -> Void,
        onSendPhoto: @escaping (UIImage) -> Void
    ) {
        self.isDirectChat = isDirectChat
        self.apiClient = apiClient
        self.matrixUseCase = matrixUseCase
        self.coreDataService = coreDataService
        self.interlocutorId = interlocutorId
        self.tappedAction = tappedAction
        self.onCamera = onCamera
        self.onSendPhoto = onSendPhoto
        fetchChatData()
        updateActions()
        fetchPhotos()
        fetchCryptoSendData()
    }
    
    func didTap(action: AttachAction) {
        guard case let .moneyTransfer(_) = action else {
            tappedAction(action)
            return
        }
        guard let rData = receiverWalletData else { return }
        let receiverWallet = UserWallletData(
            name: rData.name,
            bitcoin: rData.bitcoin,
            ethereum: rData.ethereum,
            binance: rData.binance,
            aura: rData.aura,
            url: rData.url,
            phone: rData.phone,
            walletType: .aura,
            onTap: {_ in }
        )
        let moneyAction = AttachAction.moneyTransfer(receiverWallet: receiverWallet)
        tappedAction(moneyAction)
    }
    
    func computeHeight() -> CGFloat {
        if isTransactionAvailable && isDirectChat && receiverWalletData != nil {
            return 413 - 34
        }
        return 361 - 34
    }

    // MARK: - Private Methods

    private func updateActions() {
        actions = AttachAction.allCases.compactMap {
            guard case let .moneyTransfer(_) = $0 else { return ActionItem(action: $0) }
            if isTransactionAvailable && receiverWalletData != nil {
                return ActionItem(action: $0)
            }
            return nil
        }
    }

    private func fetchChatData() {
        // TODO: Отключил для тестов
        // TODO: нужно включить флаг в Firebase
        isTransactionAvailable = true //  togglesFacade.isTransactionAvailable
        // Есть ли созданные кошельки у текущего пользователя
        Task {
            let wallets = await coreDataService.getWalletNetworks()
            await MainActor.run {
                isTransactionAvailable = wallets.isEmpty == false
            }
        }
    }

    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        if fetchResult.count > 0 {
            let totalImageCountNeeded = 50
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }

    private func fetchPhotoAtIndex(_ index: Int,
                                   _ totalImageCountNeeded: Int,
                                   _ fetchResult: PHFetchResult<PHAsset>) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .exact
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset,
                                              targetSize: PHImageManagerMaximumSize,
                                              contentMode: PHImageContentMode.aspectFit,
                                              options: requestOptions,
                                              resultHandler: { image, _ in
            if let image = image {
                self.images += [image]
            }
            if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                debugPrint("Completed array: \(self.images)")
                self.objectWillChange.send()
            }
        })
    }
    
    func fetchCryptoSendData() {
        guard let receiverUserId: String = interlocutorId else { return }
        requestUserData(userId: receiverUserId) { [weak self] result in
            guard let self = self,
                  case let .success(model) = result else {
                return
            }
            self.receiverWalletData = model
            DispatchQueue.main.async {
                self.updateActions()
                self.objectWillChange.send()
            }
            debugPrint("getUserData: \(model)")
        }
    }
    
    func requestUserData(
        userId: String,
        completion: @escaping EmptyFailureBlock<UserWallletData>
    ) {
        Publishers.Zip(
            apiClient.publisher(Endpoints.Wallet.getAssetsByUserName(userId)),
            apiClient.publisher(Endpoints.Users.getProfile(userId))
        ).sink { result in
            debugPrint("getUserData completion: \(result)")
            guard case let .failure(error) = result else {
                return
            }
            debugPrint("getUserData error: \(error)")
            completion(.failure)
        } receiveValue: { [weak self] response in
            guard let self = self else {
                completion(.failure)
                return
            }
            debugPrint("getUserData response: \(response)")
            let phone: String
            if let userPhone = response.1["phone"] as? String {
                phone = userPhone
            } else {
                phone = ""
            }

            guard let userWallets = response.0[userId],
                  let aura = userWallets["aura"]?["address"],
                  let btc = userWallets["bitcoin"]?["address"],
                  let eth = userWallets["ethereum"]?["address"],
                  let binance = userWallets["binance"]?["address"] else {
                completion(.failure)
                return
            }

            let userWallletData = UserWallletData(
                name: userId,
                bitcoin: btc,
                ethereum: eth,
                binance: binance,
                aura: aura,
                url: nil,
                phone: phone,
                walletType: .aura,
                onTap: { value in debugPrint("\(value)") }
            )

            debugPrint("getUserData userWallletData: \(userWallletData)")
            completion(.success(userWallletData))
        }
        .store(in: &cancellables)
    }
}

import Combine
import Foundation
import MatrixSDK
import SwiftUI

protocol FriendProfileViewModelProtocol: ObservableObject {
    var profile: ProfileItem { get set }
    var userId: String { get set }
    var messageText: String { get set }
    var isSnackbarPresented: Bool { get set }
    var sources: FriendProfileResourcable.Type { get }
    var showWebView: Bool { get set }
    var safari: SFSafariViewWrapper? { get set }

    func send(_ event: FriendProfileFlow.Event)
    func loadUserNote()
    func onImageViewer(imageUrl: URL)
    func onSafari(url: String)
    func onUserIdTap()
}

final class FriendProfileViewModel: FriendProfileViewModelProtocol {

    @Published var profile = ProfileItem()
    @Published var userId: String
    @Published var roomId: String
    @Published var contact: Contact?
    @Published var isSnackbarPresented = false
    @Published var messageText: String = ""
    @Published var urlToOpen: URL?
    @Published var showWebView = false
    let mediaService = MediaService()
    let sources: FriendProfileResourcable.Type
    var safari: SFSafariViewWrapper?

    // MARK: - Private Properties

    @Published private(set) var state: FriendProfileFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<FriendProfileFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<FriendProfileFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private var matrixUseCase: MatrixUseCaseProtocol
    private let userDefaults: UserDefaultsService
    private let keychainService: KeychainServiceProtocol
    private let channelFactory: ChannelUsersFactoryProtocol.Type
    private let chatHistoryCoordinator: ChatHistoryFlowCoordinatorProtocol
    private let pasteboardService: PasteboardServiceProtocol

    // MARK: - Lifecycle

    init(
        userId: String,
        roomId: String,
        chatHistoryCoordinator: ChatHistoryFlowCoordinatorProtocol,
        userDefaults: UserDefaultsService = UserDefaultsService.shared,
        keychainService: KeychainServiceProtocol = KeychainService.shared,
        channelFactory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        pasteboardService: PasteboardServiceProtocol = PasteboardService.shared,
        sources: FriendProfileResourcable.Type = FriendProfileResources.self
    ) {
        self.userId = userId
        self.roomId = roomId
        self.chatHistoryCoordinator = chatHistoryCoordinator
        self.userDefaults = userDefaults
        self.keychainService = keychainService
        self.channelFactory = channelFactory
        self.pasteboardService = pasteboardService
        self.sources = sources
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: FriendProfileFlow.Event) {
        eventSubject.send(event)
    }

    func onImageViewer(imageUrl: URL) {
        chatHistoryCoordinator.showImageViewer(image: nil, imageUrl: imageUrl)
    }

    func onSafari(url: String) {
        guard let url = URL(string: url) else { return }
        urlToOpen = url
        self.safari = SFSafariViewWrapper(link: url)
        showWebView = true
    }

    func onUserIdTap() {
        pasteboardService.copyToPasteboard(text: profile.nickname)
    }

    func loadUserNote() {
        guard let result = userDefaults.dict(forKey: .userNotes) as? [String: String] else { return }
        profile.note = result[userId] ?? ""
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onProfileAppear:
                    self?.fetchData()
                case .onAppear:
                    debugPrint("onAppear")
                case let .onShow(type):
                    switch type {
                    default:
                        ()
                    }
                case .onSocial:
                    debugPrint("onSocial")
                }
            }
            .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func loadUsers() {
        matrixUseCase.getRoomMembers(roomId: roomId) { [weak self] result in
            guard case let .success(roomMembers) = result else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let users: [ChannelParticipantsData] = self.channelFactory.makeUsersData(
                    users: roomMembers.members(with: .invite) + roomMembers.members(with: .join),
                    roomPowerLevels: MXRoomPowerLevels()
                )
                let contact = users.first(where: { $0.matrixId == self.userId }).map {
                    var displayname = ""
                    if let i = $0.matrixId.lastIndex(of: ":") {
                        let index: Int = $0.matrixId.distance(from: $0.matrixId.startIndex,
                                                              to: i)
                        self.profile.nicknameDisplay = String($0.matrixId.prefix(index))
                        displayname = String($0.matrixId.prefix(index)).removeCharacters(from: "@")
                    }
                    if $0.matrixId != $0.name {
                        displayname = $0.name
                    }
                    let contact = Contact(mxId: $0.matrixId,
                                          avatar: $0.avatar,
                                          name: displayname,
                                          status: $0.status,
                                          phone: $0.phone) { _ in
                    }
                    return contact
                }
                if let contact = contact {
                    self.setData(contact)
                }
            }
        }
    }

    private func setData(_ contact: Contact) {
        profile.mxId = contact.mxId
        profile.name = contact.name
        profile.nickname = contact.name
        profile.phone = contact.phone
        profile.avatar = contact.avatar
        loadUserNote()
    }

    private func showSnackBar(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.messageText = text
            self?.isSnackbarPresented = true
            self?.objectWillChange.send()
        }
        delay(3) { [weak self] in
            self?.messageText = ""
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }

    private func getUserData() {
        // TODO: Отрефачить логику обработки запроса
        self.apiClient.publisher(Endpoints.Users.getProfile(userId))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.showSnackBar(text: "Ошибка загрузки профиля")
                    debugPrint("Error in Get user data Api  \(error)")
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                if let phone = response["phone"] as? String {
                    self?.profile.phone = phone
                }
                let urls = (response["media"] as? Array ?? [])
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: urls, options: [])
                    let mediaResponseList = try JSONDecoder().decode([MediaResponse].self, from: jsonData)
                    self?.profile.photosUrls = mediaResponseList.compactMap {
                        return $0.original
                    }
                } catch {
                    debugPrint("Ошибка при декодировании Ленты: \(error)")
                }
                let socials = (response["social"] as? Array ?? [])
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: socials, options: [])
                    let socialResponseList = try JSONDecoder().decode([SocialResponse].self, from: jsonData)
                    self?.profile.socialNetwork = socialResponseList.compactMap {
                        guard !$0.url.isEmpty else { return nil }
                        let item = SocialListItem(
                            url: $0.url,
                            sortOrder: $0.sortOrder,
                            socialType: SocialNetworkType(rawValue: $0.socialType) ?? .facebook
                        )
                        return item
                    }
                } catch {
                    debugPrint("Ошибка при декодировании Социальных сетей: \(error)")
                }
            }
            .store(in: &subscriptions)
        let status = matrixUseCase.allUsers().first(where: { $0.userId == self.userId })?.statusMsg ?? ""
        profile.status = status
    }

    private func fetchData() {
        loadUsers()
        getUserData()
    }
}

import Combine
import SwiftUI

// MARK: - ProfileItem

struct ProfileItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var avatar: URL?
    var name = "Имя не заполнено"
    var nickname = ""
    var status = "Всем привет! Я использую AURA!"
    var info = ""
    var phone = "Номер не заполнен"
    var photos: [Image] = []
    var photos_url_preview: [URL] = []
    var photos_url_original: [URL] = []
    var social_list: [String: String] = [:]
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ProfileSceneDelegate?

    @Published var selectedImage: UIImage?

    // MARK: - Private Properties

    @Published private(set) var profile = ProfileItem()
    @Published private(set) var state: ProfileFlow.ViewState = .idle
    @Published private(set) var socialList = SocialListViewModel()
    @Published private(set) var socialListEmpty = false
    private let eventSubject = PassthroughSubject<ProfileFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ProfileFlow.ViewState, Never>(.idle)
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

    func send(_ event: ProfileFlow.Event) {
        eventSubject.send(event)
    }

    func deletePhoto(url: String) {
        apiClient.publisher(Endpoints.Media.delete_photo([url]))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    return
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.photos_url_preview = self?.profile.photos_url_preview
                    .filter { $0.absoluteString != response[0] } ?? []
            })
            .store(in: &subscriptions)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onProfileScene:
                    self?.delegate?.handleNextScene(.profileDetail)
                case .onPersonalization:
                    self?.delegate?.handleNextScene(.personalization)
                case .onSecurity:
                    self?.delegate?.handleNextScene(.security)
                case .aboutApp:
                    self?.delegate?.handleNextScene(.aboutApp)
                case .onChatSettings:
                    self?.delegate?.handleNextScene(.chatSettings)
                case .onFAQ:
                    self?.delegate?.handleNextScene(.FAQ)
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

    private func getPhotos() {
        apiClient.publisher(Endpoints.Media.get_photos(mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.photos_url_original = []
                self?.profile.photos_url_preview = []
                for x in response {
                    guard let original = x["original"] else { return }
                    guard let preview = x["preview"] else { return }
                    guard let original_url = URL(string: original) else { return }
                    guard let preview_url = URL(string: preview) else { return }
                    self?.profile.photos_url_original.append(original_url)
                    self?.profile.photos_url_preview.append(preview_url)
                }
            })
            .store(in: &subscriptions)
    }

    func addPhoto(image: UIImage) {
        guard let data = image.pngData() else { return }
        let multipartData = MultipartFileData(file: "photo",
                                              mimeType: "image/png",
                                              fileData: data)
        apiClient.publisher(Endpoints.Media.upload(multipartData, name: mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("uploadError  \(error)")
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                print("Response    \(response)")
                self?.getPhotos()
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }

    private func getSocialList() {
        state = .idle
        apiClient.publisher(Endpoints.Social.get_social(mxStore.getUserId()))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.profile.social_list = [:]
                    return
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.social_list = response
            })
            .store(in: &subscriptions)
    }

    private func updateData() {
        profile.nickname = mxStore.getUserId()
        if !mxStore.getDisplayName().isEmpty {
            profile.name = mxStore.getDisplayName()
        }
        if !mxStore.getStatus().isEmpty {
            profile.status = mxStore.getStatus()
        }
        if !mxStore.getAvatarUrl().isEmpty {
            profile.avatar = URL(fileURLWithPath: mxStore.getAvatarUrl())
        }
        getPhotos()
        profile.phone = userCredentialsStorageService.userPhoneNumber
        socialList.listData = userCredentialsStorageService.socialNetworkList.filter { $0.type == .show }
        socialListEmpty = userCredentialsStorageService.socialNetworkList.filter { $0.type == .show }.isEmpty
    }
}

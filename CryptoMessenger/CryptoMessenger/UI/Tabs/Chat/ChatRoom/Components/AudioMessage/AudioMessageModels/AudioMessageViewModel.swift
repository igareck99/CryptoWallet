import AVFoundation
import Combine

// swiftlint:disable all

// MARK: - AudioMessageViewModel

final class AudioMessageViewModel: ObservableObject {

    // MARK: - Internal properties

    let data: AudioEventItem
    
    @Published var state: AudioEventItemState
    @Published var isPlaying = false
    @Published var audioPlayer: AVAudioPlayer?
    @Published var timer = Timer.publish(every: 0.01,
                                             on: .main, in: .common).autoconnect()
    @Published var time: Double = 0
    @Published var playingAudioId = ""
    let remoteDataService: RemoteDataServiceProtocol
    let fileService: FileManagerProtocol
    
    // MARK: - Private Properties

    // MARK: - Lifecycle

    init(data: AudioEventItem,
         state: AudioEventItemState = .download,
         remoteDataService: RemoteDataServiceProtocol = RemoteDataService.shared,
         fileService: FileManagerProtocol = FileManagerService.shared) {
        self.data = data
        self.state = state
        self.remoteDataService = remoteDataService
        self.fileService = fileService
        self.initData()
    }
    
    // MARK: - Internal Methods

    func stop() {
        playingAudioId = ""
        audioPlayer?.pause()
        isPlaying = false
        timer.upstream.connect().cancel()
        self.state = .play
    }

    func play() {
        if self.isPlaying {
            stop()
            DispatchQueue.main.async {
                self.state = .stop
            }
        } else {
            playingAudioId = data.messageId
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
            timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
            audioPlayer?.play()
            isPlaying = true
            DispatchQueue.main.async {
                self.state = .stop
            }
        }
    }

    func onSlide(_ value: Double) {
        time = value
        audioPlayer?.currentTime = Double(time) * (audioPlayer?.duration ?? 0)
        audioPlayer?.play()
    }

    func onTimerChange() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.updateMeters()
            isPlaying = true
            time = Double((audioPlayer?.currentTime ?? 0) / (audioPlayer?.duration ?? 1))
            if audioPlayer?.currentTime == audioPlayer?.duration {
                self.state = .play
            }
        } else {
            isPlaying = false
            playingAudioId = ""
            timer.upstream.connect().cancel()
            time = .zero
        }
    }

    // MARK: - Private Methods
    
    private func initData() {
        let (isExist, path) = fileService.checkFileExist(name: getFileName(),
                                                         pathExtension: "mp4")
        if isExist {
            guard let path = path else { return }
            self.audioPlayer = try? AVAudioPlayer(contentsOf: path)
            self.audioPlayer?.numberOfLoops = .zero
            state = .play
        }
    }

    func start() {
        Task {
            state = .loading
            let result = await remoteDataService.downloadRequest(url: data.url)
            guard let data = result?.0,
                  let savedUrl = self.fileService.saveFile(name: getFileName(),
                                                           data: data,
                                                           pathExtension: "mp4") else {
                debugPrint("downloadDataRequest FAILED")
                return
            }
            await MainActor.run {
                self.audioPlayer = try? AVAudioPlayer(contentsOf: savedUrl)
                self.audioPlayer?.numberOfLoops = .zero
                state = .play
            }
        }
    }

    private func getFileName() -> String {
        let fileadressName = data.url.absoluteString.components(separatedBy: "/").last ?? ""
        let finalFileName = fileadressName
        return finalFileName
    }
}

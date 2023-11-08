import AVFoundation
import Combine

// swiftlint:disable all

// MARK: - AudioMessageViewModel

final class AudioMessageViewModel: ObservableObject {

    // MARK: - Internal properties

    let data: AudioEventItem
    
    @Published var state: AudioEventItemState
    @Published var isPlaying = false
    @Published var audioPlayer = AVAudioPlayer()
    var audioPlayerDelegate: AVAudioPlayerDelegate? = nil
    @Published var timer = Timer.publish(every: 0.01,
                                             on: .main, in: .common).autoconnect()
    @Published var time: Double = 0
    @Published var playingAudioId = ""
    var songDidEnd = PassthroughSubject<Void, Never>()
    let remoteDataService: RemoteDataServiceProtocol
    let fileService: FileManagerProtocol

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
        audioPlayer.pause()
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
            audioPlayer.play()
            isPlaying = true
            DispatchQueue.main.async {
                self.state = .stop
            }
        }
    }

    func onSlide(_ value: Double) {
        time = value
        audioPlayer.currentTime = Double(time) * (audioPlayer.duration)
        audioPlayer.play()
    }

    func onTimerChange() {
        if audioPlayer.isPlaying == true {
            audioPlayer.updateMeters()
            isPlaying = true
            time = Double((audioPlayer.currentTime ?? 0) / (audioPlayer.duration ?? 1))
            if audioPlayer.currentTime == audioPlayer.duration {
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
            let item = AVPlayerItem(url: path)
            guard let player = try? AVAudioPlayer(contentsOf: path) else { return }
            self.audioPlayer = player
            self.audioPlayerDelegate = AudioPlayerDelegate(endCompletion: { [weak self] in
                guard let self = self else { return }
                self.isPlaying = false
                self.state = .play
                self.playingAudioId = ""
                self.timer.upstream.connect().cancel()
                self.time = .zero
            })
            player.delegate = self.audioPlayerDelegate
            self.audioPlayer.numberOfLoops = .zero
            state = .play
        }
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        state = .stop
        audioPlayer.stop()
    }

    func start() {
        Task {
            DispatchQueue.main.async {
                self.state = .loading
            }
            let result = await remoteDataService.downloadRequest(url: data.url)
            guard let data = result?.0,
                  let savedUrl = self.fileService.saveFile(name: getFileName(),
                                                           data: data,
                                                           pathExtension: "mp4") else {
                debugPrint("downloadDataRequest FAILED")
                return
            }
            await MainActor.run {
                guard let player = try? AVAudioPlayer(contentsOf: savedUrl) else { return }
                self.audioPlayer = player
                self.audioPlayerDelegate = AudioPlayerDelegate(endCompletion: { [weak self] in
                    guard let self = self else { return }
                    self.isPlaying = false
                    self.state = .play
                    self.playingAudioId = ""
                    self.timer.upstream.connect().cancel()
                    self.time = .zero
                })
                player.delegate = self.audioPlayerDelegate
                self.audioPlayer.numberOfLoops = .zero
                state = .play
            }
        }
    }

    private func getFileName() -> String {
        let fileadressName = data.url.absoluteString.components(separatedBy: "/").last ?? ""
        let finalFileName = fileadressName
        return finalFileName
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       print("slaslsal;sa")
    }

    //Called when the AVAudioPlayer has encountered an error in the file.

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error: Error = error {
            print("audioPlayerDecodeErrorDidOccur: \(error)");
        } else {
            print("audioPlayerDecodeErrorDidOccur");
        }
    }
}


class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    
    var endCompletion: () -> Void
    
    init(endCompletion: @escaping () -> Void) {
        self.endCompletion = endCompletion
    }
    
    //Called when the AVAudioPlayer has finished playing the file.

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       endCompletion()
    }

    //Called when the AVAudioPlayer has encountered an error in the file.

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error: Error = error {
            print("audioPlayerDecodeErrorDidOccur: \(error)");
        } else {
            print("audioPlayerDecodeErrorDidOccur");
        }
    }

}

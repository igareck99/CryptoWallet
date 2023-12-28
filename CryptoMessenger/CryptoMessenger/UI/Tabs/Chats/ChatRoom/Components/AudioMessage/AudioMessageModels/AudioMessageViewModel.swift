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
        Task {
            let fileName = getFileName()
            let (isExist, fPath) = await fileService.checkFileExist(
                name: fileName,
                pathExtension: "mp4"
            )
            
            guard isExist, let path = fPath else { return }
            guard let player = try? AVAudioPlayer(contentsOf: path) else { return }
            let playerDelegate = AudioPlayerDelegate { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isPlaying = false
                    self.state = .play
                    self.playingAudioId = ""
                    self.timer.upstream.connect().cancel()
                    self.time = .zero
                }
            }
            await MainActor.run {
                audioPlayerDelegate = playerDelegate
                audioPlayer = player
                audioPlayer.delegate = playerDelegate
                audioPlayer.numberOfLoops = .zero
                state = .play
            }
        }
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        state = .stop
        audioPlayer.stop()
    }

    func start() {
        Task {
            await MainActor.run {
                self.state = .loading
            }
            guard let data = await remoteDataService.downloadRequest(url: data.url)?.0,
                  let savedUrl = await self.fileService.saveFile(
                    name: getFileName(),
                    data: data,
                    pathExtension: "mp4"
                  ) else {
                return
            }
            guard let player = try? AVAudioPlayer(contentsOf: savedUrl) else { return }
            let playerDelegate = AudioPlayerDelegate { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isPlaying = false
                    self.state = .play
                    self.playingAudioId = ""
                    self.timer.upstream.connect().cancel()
                    self.time = .zero
                }
            }
            await MainActor.run {
                audioPlayerDelegate = playerDelegate
                audioPlayer = player
                audioPlayer.delegate = playerDelegate
                audioPlayer.numberOfLoops = .zero
                state = .play
            }
        }
    }

    private func getFileName() -> String {
        let finalFileName = data.url.absoluteString.components(separatedBy: "/").last ?? ""
        return finalFileName
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       debugPrint("audioPlayerDidFinishPlaying")
    }

    // Called when the AVAudioPlayer has encountered an error in the file.

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        debugPrint("audioPlayerDecodeErrorDidOccur: error: \(String(describing: error))")
        debugPrint("audioPlayerDecodeErrorDidOccur: player: \(player)")
    }
}


class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    
    var endCompletion: () -> Void
    
    init(endCompletion: @escaping () -> Void) {
        self.endCompletion = endCompletion
    }
    
    // Called when the AVAudioPlayer has finished playing the file.

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       endCompletion()
    }

    // Called when the AVAudioPlayer has encountered an error in the file.

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error: Error = error {
            print("audioPlayerDecodeErrorDidOccur: \(error)");
        } else {
            print("audioPlayerDecodeErrorDidOccur");
        }
    }

}

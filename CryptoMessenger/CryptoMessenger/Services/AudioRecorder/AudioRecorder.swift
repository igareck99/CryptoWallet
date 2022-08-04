import Foundation
import SwiftUI
import AVFoundation
import Combine

// MARK: - AudioRecorder

final class AudioRecorder: ObservableObject {

    // MARK: - Internal Properties

    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder?
    var recordingSession : AVAudioSession?
    var localUrl: URL?
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }

    // MARK: - Internal Methods

    func startRecording() {
        do {
            self.recordingSession = AVAudioSession.sharedInstance()
            try self.recordingSession?.setCategory(.record)
        } catch {
            debugPrint("Error create Session AVAudio")
        }
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath
                            .appendingPathComponent("AudioMessage_\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename,
                                                settings: settings)
            localUrl = audioFilename
            audioRecorder?.record()
            recording = true
        } catch {
            debugPrint("Could not start recording")
        }
    }

    func stopRecording() {
        recording = false
        guard let unwrappedAudioRecorder = audioRecorder else { return }
        unwrappedAudioRecorder.stop()
    }

    func fetchRecordings(completion: @escaping (RecordingDataModel?) -> Void ) {
        guard let localUrl = localUrl else {
            completion(nil)
            return
        }

        let item = AVPlayerItem(url: localUrl)
        var duration = Int(Double(item.asset.duration.value) / Double(item.asset.duration.timescale) * 1000)
        if duration == 0 {
            duration = 70000
        }
        let recording = RecordingDataModel(fileURL: localUrl,
                                           createdAt: getCreationDate(for: localUrl),
                                           duration: duration)
        completion(recording)
        objectWillChange.send(self)
    }

    func clearData() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let directoryContents = try fileManager
                                    .contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for item in directoryContents {
                deleteRecording(urlsToDelete: [item])
            }
        } catch {
            debugPrint("Error while clear directory")
        }
    }

    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                debugPrint("File could not be deleted!")
            }
        }
    }
}

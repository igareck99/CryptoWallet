import Foundation
import Combine

// MARK: - TimerViewModel

final class TimerViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @Published var startTime = Date()
    @Published var timerString = "00:00"

    // MARK: - Internal Methods

    func getTime() {
        let t =  Date().timeIntervalSince(startTime)
        let minutes = (Int(Date().timeIntervalSince(startTime) / 60))
        let seconds =  Int(Date().timeIntervalSince(startTime).truncatingRemainder(dividingBy: 60))
        timerString = String(minutes < 10 ? "0" + String(minutes) : String(minutes)) + ":"
        + String(seconds < 10 ? "0" + String(seconds): String(seconds))
    }
}

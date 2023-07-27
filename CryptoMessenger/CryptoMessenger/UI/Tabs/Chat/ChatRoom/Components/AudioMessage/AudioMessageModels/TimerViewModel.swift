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
        timerString = String(Int(Date().timeIntervalSince(startTime) / 60)) + ":"
        timerString += Date().timeIntervalSince(startTime).truncatingRemainder(dividingBy: 60) > 10 ?
        String(format: "%.2f", (Date().timeIntervalSince(startTime).truncatingRemainder(dividingBy: 60))) :
        "0" + String(format: "%.2f", (Date().timeIntervalSince(startTime).truncatingRemainder(dividingBy: 60)))
    }
}

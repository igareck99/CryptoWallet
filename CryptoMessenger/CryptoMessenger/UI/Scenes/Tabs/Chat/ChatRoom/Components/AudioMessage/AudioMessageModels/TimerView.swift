import SwiftUI

// MARK: - TimerView

struct TimerView: View {

    // MARK: - Internal Properties

    @State var isTimerRunning = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // MARK: - Private Properties

    @State var startTime = Date()
    @State var timerString = "00.00"

    // MARK: - Body

    var body: some View {
        Text(self.timerString)
            .font(.regular(15))
            .foreground(.black())
            .onReceive(timer) { _ in
                if self.isTimerRunning {
                    timerString = Date().timeIntervalSince(self.startTime) > 10 ?
                    String(format: "%.2f", (Date().timeIntervalSince(self.startTime))) :
                    "0" + String(format: "%.2f", (Date().timeIntervalSince(self.startTime)))
                }
            }
    }
}

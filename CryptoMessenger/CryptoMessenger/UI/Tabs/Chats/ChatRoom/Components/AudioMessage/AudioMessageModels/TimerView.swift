import SwiftUI

// MARK: - TimerView

struct TimerView: View {

    // MARK: - Internal Properties

    @State var isTimerRunning = false
    @StateObject var viewModel = TimerViewModel()

    // MARK: - Private Properties

    // MARK: - Body

    var body: some View {
        Text(viewModel.timerString)
            .font(.subheadlineRegular15)
            .foregroundColor(.chineseBlack)
            .onReceive(viewModel.timer) { _ in
                if self.isTimerRunning {
                    viewModel.getTime()
                }
            }
    }
}
import UIKit

// MARK: - TimerResult

typealias TimerResult = (hours: String, minutes: String, seconds: String)

// MARK: - CountdownTimerDelegate

protocol CountdownTimerDelegate: AnyObject {
    func countdownTimerDidFinish()
    func countdownTime(_ timerResult: TimerResult)
}

// MARK: - CountdownTimer

final class CountdownTimer {

    // MARK: - Internal Properties

    weak var delegate: CountdownTimerDelegate?

    // MARK: - Private Methods

    private var hours = 0.0
    private var minutes = 0.0
    private var seconds = 0.0
    private var duration = 0.0
    private var endTime: CFTimeInterval?
    private var displayLink: CADisplayLink?

    // MARK: - Lifecycle

    init(seconds: Double, minutes: Double = 0, hours: Double = 0) {
        self.seconds = seconds
        self.minutes = minutes
        self.hours = hours
    }

    // MARK: - Internal Methods

    func setDuration(_ seconds: Int) {
        self.duration = Double(seconds)

        let minutes = seconds / 60
        let seconds = seconds % 60

        self.seconds = Double(seconds)
        self.minutes = Double(minutes)
    }

    func start() {
        timerDone()
        setupDisplayLink()
        displayLink?.isPaused = false
    }

    func pause() {
        displayLink?.isPaused = true
    }

    func stop() {
        timerDone()
    }

    // MARK: - Actions

    @objc private func handleUpdate() {
        guard let endTime = endTime else { return }

        let now = CACurrentMediaTime()
        if now > endTime {
            timerDone()
        } else {
            duration = endTime - now + 1
            delegate?.countdownTime(getTimerResult(duration))
        }
    }

    // MARK: - Private Methods

    func setupDisplayLink() {
        let hoursToSeconds = hours * 3600
        let minutesToSeconds = minutes * 60
        let secondsToSeconds = seconds

        let seconds = secondsToSeconds + minutesToSeconds + hoursToSeconds
        self.seconds = Double(seconds)
        self.duration = Double(seconds)

        let startTime = CACurrentMediaTime()
        endTime = duration + startTime

        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.isPaused = true
        displayLink?.add(to: .main, forMode: .common)
    }

    private func getTimerResult(_ time: Double) -> TimerResult {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60

        return TimerResult(
            String(format: "%02i", hours),
            String(format: "%02i", minutes),
            String(format: "%02i", seconds)
        )
    }

    private func timerDone() {
        displayLink?.isPaused = true
        displayLink?.invalidate()
        displayLink = nil
        duration = seconds
        delegate?.countdownTimerDidFinish()
    }
}

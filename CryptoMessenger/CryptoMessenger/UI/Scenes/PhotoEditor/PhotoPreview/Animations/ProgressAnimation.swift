import UIKit

// MARK: - Animator

final class Animator {

    // MARK: - Internal Properties

    var currentProgress: CGFloat = 0

    // MARK: - Private Properties

    private var displayLink: CADisplayLink?
    private var fromProgress: CGFloat = 0
    private var toProgress: CGFloat = 0
    private var startTimeInterval: TimeInterval = 0
    private var endTimeInterval: TimeInterval = 0
    private var completion: ((Bool) -> Void)?
    private let onProgress: (CGFloat, CGFloat) -> Void
    private let timing: (CGFloat) -> (CGFloat)

    // MARK: - Lifecycle

    required init(onProgress: @escaping (CGFloat, CGFloat) -> Void,
                  easing: Easing<CGFloat> = .linear) {
        self.currentProgress = .zero
        self.onProgress = onProgress
        self.timing = easing.function
    }

    // MARK: - Actions

    @objc private func onProgressChanged(link: CADisplayLink) {
        let currentTime = CACurrentMediaTime()
        var currentProgress = CGFloat((currentTime - startTimeInterval) / (endTimeInterval - startTimeInterval))

        currentProgress = min(1, currentProgress)

        let tick = timing(currentProgress) - timing(currentProgress)
        currentProgress = fromProgress + (toProgress - fromProgress) * currentProgress

        onProgress(timing(currentProgress), tick)

        if currentProgress >= 1 {
            displayLink?.invalidate()
            displayLink = nil
            completion?(true)
        }
    }

    // MARK: - Internal Methods

    func animate(duration: TimeInterval, completion: ((Bool) -> Void)?) {
        if displayLink != nil {
            self.completion?(false)
        }
        self.completion = completion
        fromProgress = currentProgress
        toProgress = 1
        startTimeInterval = CACurrentMediaTime()
        endTimeInterval = startTimeInterval + duration * TimeInterval(abs(toProgress - fromProgress))

        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(onProgressChanged))
        displayLink?.add(to: .main, forMode: .common)
    }

    func cancel() {
        if displayLink != nil {
            completion?(false)
        }
        displayLink?.invalidate()
        displayLink = nil
    }
}

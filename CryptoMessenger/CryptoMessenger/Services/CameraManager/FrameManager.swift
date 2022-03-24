import AVFoundation

// MARK: - FrameManager

final class FrameManager: NSObject, ObservableObject {

    // MARK: - Static Properties

    static let shared = FrameManager()

    // MARK: - Internal Properties

    @Published var current: CVPixelBuffer?
    let videoOutputQueue = DispatchQueue(
        label: "com.aura.FrameManager",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem
    )

    // MARK: - Life Cycle

    private override init() {
        super.init()
        CameraManager.shared.set(self, queue: videoOutputQueue)
    }
}

// MARK: - FrameManager (AVCaptureVideoDataOutputSampleBufferDelegate)

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async { self.current = buffer }
        }
    }
}

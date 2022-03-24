import AVFoundation

// MARK: - CameraManager

final class CameraManager: ObservableObject {

    // MARK: - Status

    enum Status {

        // MARK: - Types

        case unconfigured
        case configured
        case unauthorized
        case failed
    }

    // MARK: - Static Properties

    static let shared = CameraManager()

    // MARK: - Internal Properties

    @Published var error: CameraError?
    let session = AVCaptureSession()

    // MARK: - Private Properties

    private let sessionQueue = DispatchQueue(label: "com.aura.CameraManager")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = Status.unconfigured

    // MARK: - Life Cycle

    private init() {
        configure()
    }

    // MARK: - Private Methods

    private func set(error: CameraError?) {
        DispatchQueue.main.async { self.error = error }
    }

    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            status = .unauthorized
            set(error: .unknownAuthorization)
        }
    }

    private func configureCaptureSession() {
        guard status == .unconfigured else { return }

        session.beginConfiguration()

        defer {
            session.commitConfiguration()
        }

        let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }

        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch {
            set(error: .createCaptureInput(error))
            status = .failed
            return
        }

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)

            videoOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
        } else {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }

        status = .configured
    }

    private func configure() {
        checkPermissions()

        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
    }

    func set(
        _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
        queue: DispatchQueue
    ) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
}

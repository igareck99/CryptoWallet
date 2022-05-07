import AVFoundation
import UIKit

// MARK: - CodeScannerView

extension CodeScannerView {

    // MARK: - ScannerViewController

    final class ScannerViewController: UIViewController,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate {

        // MARK: - Internal Properties

        var delegate: ScannerCoordinator?

        // MARK: - Private Properties

        private let showFinderView: Bool
        private var isGalleryShowing = false {
            didSet {
                if delegate?.parent.isGalleryPresented.wrappedValue != isGalleryShowing {
                    delegate?.parent.isGalleryPresented.wrappedValue = isGalleryShowing
                }
            }
        }

        // MARK: - Lifecycle

        init(showFinderView: Bool = false) {
            self.showFinderView = showFinderView
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            self.showFinderView = false
            super.init(coder: coder)
        }

        // MARK: - Internal Methods

        func openGallery() {
            isGalleryShowing = true
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }

        @objc func openGalleryFromButton(_ sender: UIButton) {
            openGallery()
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            isGalleryShowing = false

            guard
                let image = info[.originalImage] as? UIImage,
                let detector = CIDetector(
                    ofType: CIDetectorTypeQRCode,
                    context: nil,
                    options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
                ),
                let ciImage = CIImage(image: image)
            else {
                return
            }

            var qrCodeLink = ""

            let features = detector.features(in: ciImage)

            for feature in features as! [CIQRCodeFeature] {
                guard let feature = feature.messageString else { return }
                qrCodeLink += feature
            }

            if qrCodeLink.isEmpty {
                delegate?.didFail(reason: .badOutput)
            } else {
                let result = ScanResult(string: qrCodeLink, type: .qr)
                delegate?.found(result)
            }

            dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isGalleryShowing = false
        }

#if targetEnvironment(simulator)
        override public func loadView() {
            view = UIView()
            view.isUserInteractionEnabled = true

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.text = "You're running in the simulator, which means the camera isn't available. Tap anywhere to send back some simulated data."
            label.textAlignment = .center

            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Select a custom image", for: .normal)
            button.setTitleColor(UIColor.systemBlue, for: .normal)
            button.setTitleColor(UIColor.gray, for: .highlighted)
            button.addTarget(self, action: #selector(openGalleryFromButton), for: .touchUpInside)

            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 50
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(button)

            view.addSubview(stackView)

            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 50),
                stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }

        override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let simulatedData = delegate?.parent.simulatedData else {
                debugPrint("Simulated Data Not Provided!")
                return
            }

            // Send back their simulated data, as if it was one of the types they were scanning for
            let result = ScanResult(string: simulatedData, type: delegate?.parent.codeTypes.first ?? .qr)
            delegate?.found(result)
        }
#else

        // MARK: - Internal Properties

        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        let fallbackVideoCaptureDevice = AVCaptureDevice.default(for: .video)
        override var prefersStatusBarHidden: Bool { true }
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

        // MARK: - Private Properties

        private lazy var finderView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = R.image.scanner.finder()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(updateOrientation),
                name: Notification.Name("UIDeviceOrientationDidChangeNotification"),
                object: nil
            )
            view.backgroundColor = .black
            captureSession = AVCaptureSession()

            guard let videoCaptureDevice = delegate?.parent.videoCaptureDevice ?? fallbackVideoCaptureDevice else {
                return
            }
            let videoInput: AVCaptureDeviceInput

            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                delegate?.didFail(reason: .initError(error))
                return
            }
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                delegate?.didFail(reason: .badInput)
                return
            }
            let metadataOutput = AVCaptureMetadataOutput()

            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = delegate?.parent.codeTypes
            } else {
                delegate?.didFail(reason: .badOutput)
                return
            }
        }

        // MARK: - Lifecycle
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }

        override func viewWillLayoutSubviews() { previewLayer?.frame = view.layer.bounds }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            updateOrientation()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            if previewLayer == nil {
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            }

            previewLayer.frame = view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)

            addFinderView()

            delegate?.reset()

            if captureSession?.isRunning == false {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.captureSession.startRunning()
                }
            }
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)

            if captureSession?.isRunning == true {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.captureSession.stopRunning()
                }
            }
        }

        // MARK: - Internal Methods

        @objc func updateOrientation() {
            guard
                let orientation = view.window?.windowScene?.interfaceOrientation,
                let connection = captureSession.connections.last, connection.isVideoOrientationSupported
            else {
                return
            }

            connection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) ?? .portrait
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard
                touches.first?.view == view,
                let touchPoint = touches.first,
                let device = delegate?.parent.videoCaptureDevice ?? fallbackVideoCaptureDevice
            else {
                return
            }

            guard let videoView = view else { return }
            let screenSize = videoView.bounds.size
            let xPoint = touchPoint.location(in: videoView).y / screenSize.height
            let yPoint = 1.0 - touchPoint.location(in: videoView).x / screenSize.width
            let focusPoint = CGPoint(x: xPoint, y: yPoint)

            do {
                try device.lockForConfiguration()
            } catch {
                return
            }

            device.focusPointOfInterest = focusPoint
            device.focusMode = .continuousAutoFocus
            device.exposurePointOfInterest = focusPoint
            device.exposureMode = .continuousAutoExposure
            device.unlockForConfiguration()
        }

        // MARK: - Private Methods

        private func addFinderView() {
            guard showFinderView else { return }

            view.addSubview(finderView)
            view.bringSubviewToFront(finderView)

            NSLayoutConstraint.activate([
                finderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                finderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                finderView.widthAnchor.constraint(equalToConstant: 200),
                finderView.heightAnchor.constraint(equalToConstant: 200)
            ])
        }

#endif

        func updateViewController(isTorchOn: Bool, isGalleryPresented: Bool) {
            if let backCamera = AVCaptureDevice.default(for: AVMediaType.video),
               backCamera.hasTorch {
                try? backCamera.lockForConfiguration()
                backCamera.torchMode = isTorchOn ? .on : .off
                backCamera.unlockForConfiguration()
            }

            if isGalleryPresented && !isGalleryShowing {
                openGallery()
            }
        }
    }
}

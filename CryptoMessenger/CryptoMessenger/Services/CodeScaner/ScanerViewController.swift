import AVFoundation
import UIKit

extension CodeScannerView {

    final class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var delegate: ScannerCoordinator?
        private let showFinderView: Bool
        private var isGalleryShowing = false {
            didSet {
                if delegate?.parent.isGalleryPresented.wrappedValue != isGalleryShowing {
                    delegate?.parent.isGalleryPresented.wrappedValue = isGalleryShowing
                }
            }
        }

        init(showFinderView: Bool = false) {
            self.showFinderView = showFinderView
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            self.showFinderView = false
            super.init(coder: coder)
        }

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
                qrCodeLink += feature.messageString!
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

        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        let fallbackVideoCaptureDevice = AVCaptureDevice.default(for: .video)

        private lazy var finderView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = R.image.scanner.finder()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

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

        override func viewWillLayoutSubviews() { previewLayer?.frame = view.layer.bounds }

        @objc func updateOrientation() {
            guard
                let orientation = view.window?.windowScene?.interfaceOrientation,
                let connection = captureSession.connections.last, connection.isVideoOrientationSupported
            else {
                return
            }
    
            connection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) ?? .portrait
        }

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

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)

            if captureSession?.isRunning == true {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.captureSession.stopRunning()
                }
            }

            NotificationCenter.default.removeObserver(self)
        }

        override var prefersStatusBarHidden: Bool { true }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard
                touches.first?.view == view,
                let touchPoint = touches.first,
                let device = delegate?.parent.videoCaptureDevice ?? fallbackVideoCaptureDevice
            else {
                return
            }

            let videoView = view
            let screenSize = videoView!.bounds.size
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

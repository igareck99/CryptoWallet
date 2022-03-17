import AVFoundation
import SwiftUI

// MARK: - ScanError

enum ScanError: Error {

    // MARK: - Types

    case badInput
    case badOutput
    case initError(_ error: Error)
}

// MARK: - ScanResult

struct ScanResult {

    // MARK: - Internal Properties

    let string: String
    let type: AVMetadataObject.ObjectType
}

// MARK: - ScanMode

enum ScanMode {

    // MARK: - Types

    case once
    case oncePerCode
    case continuous
}

// MARK: - CodeScannerView

struct CodeScannerView: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    let codeTypes: [AVMetadataObject.ObjectType]
    let scanMode: ScanMode
    let scanInterval: Double
    let showFinderView: Bool
    var simulatedData = ""
    var shouldVibrateOnSuccess: Bool
    var isTorchOn: Bool
    var isGalleryPresented: Binding<Bool>
    var videoCaptureDevice: AVCaptureDevice?
    var completion: (Result<ScanResult, ScanError>) -> Void

    // MARK: - Lifecycle

    init(
        codeTypes: [AVMetadataObject.ObjectType],
        scanMode: ScanMode = .once,
        scanInterval: Double = 2.0,
        showFinderView: Bool = false,
        simulatedData: String = "",
        shouldVibrateOnSuccess: Bool = true,
        isTorchOn: Bool = false,
        isGalleryPresented: Binding<Bool> = .constant(false),
        videoCaptureDevice: AVCaptureDevice? = .default(for: .video),
        completion: @escaping (Result<ScanResult, ScanError>) -> Void
    ) {
        self.codeTypes = codeTypes
        self.scanMode = scanMode
        self.showFinderView = showFinderView
        self.scanInterval = scanInterval
        self.simulatedData = simulatedData
        self.shouldVibrateOnSuccess = shouldVibrateOnSuccess
        self.isTorchOn = isTorchOn
        self.isGalleryPresented = isGalleryPresented
        self.videoCaptureDevice = videoCaptureDevice
        self.completion = completion
    }

    // MARK: - Internal Methods

    func makeCoordinator() -> ScannerCoordinator { .init(parent: self) }

    func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController(showFinderView: showFinderView)
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        uiViewController.updateViewController(
            isTorchOn: isTorchOn,
            isGalleryPresented: isGalleryPresented.wrappedValue
        )
    }
}

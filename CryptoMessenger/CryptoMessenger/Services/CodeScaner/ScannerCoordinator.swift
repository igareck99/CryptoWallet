import AVFoundation
import SwiftUI

// MARK: - ScanError

extension CodeScannerView {

    // MARK: - ScannerCoordinator

    final class ScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CodeScannerView
        var codesFound = Set<String>()
        var didFinishScanning = false
        var lastTime = Date(timeIntervalSince1970: 0)
        var isPastScanInterval: Bool { Date().timeIntervalSince(lastTime) >= parent.scanInterval }
        
        // MARK: - LifeCycle

        init(parent: CodeScannerView) {
            self.parent = parent
        }
        // MARK: - Internal Methods

        func reset() {
            codesFound.removeAll()
            didFinishScanning = false
            lastTime = Date(timeIntervalSince1970: 0)
        }

        func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            if let metadataObject = metadataObjects.first {
                guard
                    let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                    let stringValue = readableObject.stringValue,
                    !didFinishScanning
                else {
                    return
                }
                
                let result = ScanResult(string: stringValue, type: readableObject.type)

                switch parent.scanMode {
                case .once:
                    found(result)
                    didFinishScanning = true
                case .oncePerCode:
                    if !codesFound.contains(stringValue) {
                        codesFound.insert(stringValue)
                        found(result)
                    }
                case .continuous:
                    if isPastScanInterval {
                        found(result)
                    }
                }
            }
        }

        func found(_ result: ScanResult) {
            lastTime = Date()

            if parent.shouldVibrateOnSuccess {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }

            parent.completion(.success(result))
        }

        func didFail(reason: ScanError) {
            parent.completion(.failure(reason))
        }
    }
}

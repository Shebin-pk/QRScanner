//
//  QRCodeScannerView.swift
//  QRScanner
//
//  Created by Shebin PK on 27/12/23.
//

import AVFoundation
import SwiftUI

struct QRCodeScannerView: UIViewControllerRepresentable {
    
    /// Coordinator to handle camera metadata (QR code) output.
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView

        init(parent: QRCodeScannerView) {
            self.parent = parent
        }

        /// Triggered when the camera detects a QR code.
        func metadataOutput(_ output: AVCaptureMetadataOutput,
                            didOutput metadataObjects: [AVMetadataObject],
                            from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first,
               let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
               let stringValue = readableObject.stringValue {
                
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // Haptic feedback
                parent.didFindCode(stringValue) // Send scanned code back to parent
            }
        }
    }

    /// Callback for when a QR code is found.
    var didFindCode: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let session = AVCaptureSession()

        // Setup camera input
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              session.canAddInput(videoInput) else {
            return viewController
        }
        session.addInput(videoInput)

        // Setup metadata (QR code) output
        let metadataOutput = AVCaptureMetadataOutput()
        guard session.canAddOutput(metadataOutput) else { return viewController }
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]

        // Add live camera preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        session.startRunning()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

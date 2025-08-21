//
//  ContentView.swift
//  QRScanner
//
//  Created by Shebin PK on 27/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var scannedCode: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let code = scannedCode {
                    // Add your logic to navigate based on the API response
                    // Show scanned result
                    
                    Text("Scanned Code: \(code)")
                        .font(.headline)
                        .padding()

                    Button(action: {
                        scannedCode = nil // Reset to show scanner again
                    }) {
                        Text("Scan Again")
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else {
                    // Show the QR code scanner
                    QRCodeScannerView { code in
                        scannedCode = code
                    }
                    .navigationBarTitle("QR Code Scanner")
                }
            }
            .padding()
        }
    }
}

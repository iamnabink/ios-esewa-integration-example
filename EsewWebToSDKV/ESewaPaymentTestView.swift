//
//  ESewaPaymentView.swift
//  EsewWebToSDK
//
//  Created by Nabraj Khadka on 08/09/2025.
//

import Foundation
import SwiftUI
import WebKit
import CryptoKit
import Foundation


// MARK: - Complete Payment View (Updated)
public struct ESewaPaymentTestView: View {
    let config: ESewaPaymentConfig
    @Environment(\.dismiss) private var dismiss
    
    @State private var isLoading = true
    @State private var currentURL: String?
    @State private var paymentStatus: String = "Initializing Payment..."
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    public init(config: ESewaPaymentConfig) {
            self.config = config
        }
    
    private let esewaURL = URL(string: "https://rc-epay.esewa.com.np/api/epay/main/v2/form")!
    
   public var body: some View {
        NavigationView {
            VStack {
                // Payment Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Amount:")
                            .fontWeight(.medium)
                        Spacer()
                        Text("Rs. \(config.totalAmount)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Status:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(paymentStatus)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Use the fixed WebView
                CustomESewaWebView(
                    postData: config.generatePaymentData(),
                    url: esewaURL,
                    isLoading: $isLoading,
                    currentURL: $currentURL,
                    onSuccess: { url in
                        alertTitle = "Payment Successful"
                        alertMessage = "Your payment has been completed successfully!"
                        paymentStatus = "Payment Successful ✅"
                        showAlert = true
                    },
                    onFailure: { url in
                        alertTitle = "Payment Failed"
                        alertMessage = "Your payment could not be processed. Please try again."
                        paymentStatus = "Payment Failed ❌"
                        showAlert = true
                    }
                )
            }
            .navigationTitle("eSewa Payment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(alertMessage)
            }
            .onChange(of: currentURL) { url in
                if let url = url {
                    if url.contains("success") {
                        paymentStatus = "Payment Successful ✅"
                    } else if url.contains("failure") {
                        paymentStatus = "Payment Failed ❌"
                    } else if !isLoading {
                        paymentStatus = "Processing payment..."
                    }
                }
            }
        }
    }
}

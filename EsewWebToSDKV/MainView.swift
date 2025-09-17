//
//  ContentView.swift
//  EsewWebToSDK
//
//  Created by Nabraj Khadka on 08/09/2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    var body: some View {
        PaymentView()
    }
}
#Preview {
    MainView()
}



// MARK: - Custom Payment Configuration View
struct PaymentView: View {
    @State private var amount = "500"
    @State private var productCode = "EPAYTEST"
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Payment Configuration")
                            .font(.headline)
                        
                        VStack(alignment: .leading) {
                            Text("Amount (Rs.)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Enter amount", text: $amount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Product Code")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Product code", text: $productCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    NavigationLink(destination: {
                        let config = ESewaPaymentConfig(
                            amount: amount,
                            taxAmount: "0",
                            productServiceCharge: "0",
                            productDeliveryCharge: "0",
                            productCode: productCode,
                            successURL: "https://developer.esewa.com.np/success",
                            failureURL: "https://developer.esewa.com.np/failure"
                        )
                        return ESewaPaymentTestView(config: config)
                    }) {
                        Text("Proceed to Payment")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("eSewa Integration")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}


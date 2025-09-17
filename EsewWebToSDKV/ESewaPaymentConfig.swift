//
//  ESewaPaymentConfig.swift
//  EsewWebToSDK
//
//  Created by Nabraj Khadka on 08/09/2025.
//

import Foundation


//eSewa ID: 9806800001/2/3/4/5cc
// Password : Nepal@123
//Token:123456

public struct ESewaPaymentConfig {
    public  let amount: String
    public let taxAmount: String
    public  let productServiceCharge: String
    public   let productDeliveryCharge: String
    public   let productCode: String
    public  let successURL: String
    public  let failureURL: String
    
    var totalAmount: String {
        let amount = Double(self.amount) ?? 0
        let tax = Double(taxAmount) ?? 0
        let serviceCharge = Double(productServiceCharge) ?? 0
        let deliveryCharge = Double(productDeliveryCharge) ?? 0
        return String(amount + tax + serviceCharge + deliveryCharge)
    }
    
    func generatePaymentData() -> [String: String] {
        // Generate fresh credentials for each request
        let transactionUUID = ESewaSignatureGenerator.generateTransactionUUID()
        let signature = ESewaSignatureGenerator.generateSignature(
            totalAmount: totalAmount,
            transactionUUID: transactionUUID,
            productCode: productCode
        )
        
        let paymentData = [
            "amount": amount,
            "tax_amount": taxAmount,
            "total_amount": totalAmount,
            "product_service_charge": productServiceCharge,
            "product_delivery_charge": productDeliveryCharge,
            "transaction_uuid": transactionUUID,
            "product_code": productCode,
            "success_url": successURL,
            "failure_url": failureURL,
            "signed_field_names": "total_amount,transaction_uuid,product_code",
            "signature": signature
        ]
        
        // Debug logging for verification
        print("=== New Payment Request Generated ===")
        print("Transaction UUID: \(transactionUUID)")
        print("Total Amount: \(totalAmount)")
        print("Signature: \(signature)")
        print("Signed Data: total_amount=\(totalAmount),transaction_uuid=\(transactionUUID),product_code=\(productCode)")
        
        return paymentData
    }
    // Public initializer
        public init(
            amount: String,
            taxAmount: String,
            productServiceCharge: String,
            productDeliveryCharge: String,
            productCode: String,
            successURL: String,
            failureURL: String
        ) {
            self.amount = amount
            self.taxAmount = taxAmount
            self.productServiceCharge = productServiceCharge
            self.productDeliveryCharge = productDeliveryCharge
            self.productCode = productCode
            self.successURL = successURL
            self.failureURL = failureURL
        }
    
    static var testConfig: ESewaPaymentConfig {
        ESewaPaymentConfig(
            amount: "100",
            taxAmount: "0",
            productServiceCharge: "0",
            productDeliveryCharge: "0",
            productCode: "EPAYTEST",
            successURL: "https://developer.esewa.com.np/success",
            failureURL: "https://developer.esewa.com.np/failure"
        )
    }
}

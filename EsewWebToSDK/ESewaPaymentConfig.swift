//
//  ESewaPaymentConfig.swift
//  EsewWebToSDK
//
//  Created by Nabraj Khadka on 08/09/2025.
//

import Foundation


//eSewa ID: 9806800001/2/3/4/5cc
//Token:123456

// MARK: - eSewa Payment Configuration
struct ESewaPaymentConfig {
    let amount: String
    let taxAmount: String
    let productServiceCharge: String
    let productDeliveryCharge: String
    let productCode: String
    let successURL: String
    let failureURL: String
    
    var totalAmount: String {
        let amount = Double(self.amount) ?? 0
        let tax = Double(taxAmount) ?? 0
        let serviceCharge = Double(productServiceCharge) ?? 0
        let deliveryCharge = Double(productDeliveryCharge) ?? 0
        return String(amount + tax + serviceCharge + deliveryCharge)
    }
    
    func generatePaymentData() -> [String: String] {
        let transactionUUID = ESewaSignatureGenerator.generateTransactionUUID()
        let signature = ESewaSignatureGenerator.generateSignature(
            totalAmount: totalAmount,
            transactionUUID: transactionUUID,
            productCode: productCode
        )
        
        return [
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

//
//  ESewaSignatureGenerator.swift
//  EsewWebToSDK
//
//  Created by Nabraj Khadka on 08/09/2025.
//

import SwiftUI
import WebKit
import CryptoKit
import Foundation

// MARK: - Signature Generator
struct ESewaSignatureGenerator {
    private static let secretKey = "8gBm/:&EnhH.1/q"
    
    static func generateSignature(totalAmount: String, transactionUUID: String, productCode: String) -> String {
        let signedData = "total_amount=\(totalAmount),transaction_uuid=\(transactionUUID),product_code=\(productCode)"
        
        let key = SymmetricKey(data: Data(secretKey.utf8))
        let signature = HMAC<SHA256>.authenticationCode(for: Data(signedData.utf8), using: key)
        
        return Data(signature).base64EncodedString()
    }
    
    static func generateTransactionUUID() -> String {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        let random = Int.random(in: 100...999)
        return "TXN-\(timestamp)-\(random)"
    }
}


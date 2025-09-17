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
        // Fixed: Match the exact format from HTML - no spaces around commas
        let signedData = "total_amount=\(totalAmount),transaction_uuid=\(transactionUUID),product_code=\(productCode)"
        
        let key = SymmetricKey(data: Data(secretKey.utf8))
        let signature = HMAC<SHA256>.authenticationCode(for: Data(signedData.utf8), using: key)
        
        return Data(signature).base64EncodedString()
    }
    
    static func generateTransactionUUID() -> String {
        // Match HTML exactly: Date.now() gives milliseconds, Math.floor(Math.random() * 1000) gives 0-999
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        let random = Int.random(in: 0..<1000) // This matches Math.floor(Math.random() * 1000)
        return "TXN-\(timestamp)-\(random)"
    }
}


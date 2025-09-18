# EsewWebToSDKV - iOS eSewa Payment Integration Framework

A native iOS XCFramework that provides seamless integration with eSewa payment gateway, converting web-based payment flows into a native iOS experience.

# Release: EsewWebToSDKV.xcframework

This section explains how to build the `EsewWebToSDKV` XCFramework from source. The XCFramework supports both **iOS devices** and **simulators**.

---

### 1. Prerequisites

* Xcode 16 or later
* macOS system with Terminal
* Project source checked out locally
* The `EsewWebToSDKV` framework target in your project

---

### 2. Build the framework for iOS devices (Archive)

1. Open your project in Xcode.
2. Select the **`EsewWebToSDKV` scheme**.
3. Choose **Generic iOS Device** as the build target.
4. Make sure the following Build Settings are correct for the framework target:

   * `SKIP_INSTALL = NO`
   * `BUILD_LIBRARY_FOR_DISTRIBUTION = YES`
5. Archive the framework:

   * **Product → Archive**
6. After archiving, locate the framework in Finder:

   ```
   ~/Library/Developer/Xcode/Archives/<date>/<archive-name>.xcarchive/Products/Library/Frameworks/EsewWebToSDKV.framework
   ```

---

### 3. Build the framework for iOS Simulator

From your **project root** in Terminal:

```bash
mkdir -p build/iphonesimulator

xcodebuild build \
  -scheme EsewWebToSDKV \
  -configuration Release \
  -sdk iphonesimulator \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO \
  BUILD_DIR=build/iphonesimulator
```

The simulator framework will be at:

```
build/iphonesimulator/Release-iphonesimulator/EsewWebToSDKV.framework
```

---

### 4. Create the XCFramework

Run the following Terminal command from your **project root** (adjust archive name if different):

```bash
xcodebuild -create-xcframework \
  -framework "/Users/<your-username>/Library/Developer/Xcode/Archives/<date>/EsewWebToSDKV <date-time>.xcarchive/Products/Library/Frameworks/EsewWebToSDKV.framework" \
  -framework "build/iphonesimulator/Release-iphonesimulator/EsewWebToSDKV.framework" \
  -output EsewWebToSDKV.xcframework
```

After this, the **`EsewWebToSDKV.xcframework`** will appear in the current directory.

---

### 5. Add the XCFramework to your project

1. Drag the `EsewWebToSDKV.xcframework` into your Xcode app project.
2. Go to your app target → **General → Frameworks, Libraries, and Embedded Content**.
3. Set it to **Embed & Sign**.
4. You can now `import EsewWebToSDKV` in your Swift code.

---

### 6. Notes

* You only need to rebuild the XCFramework when the source framework changes.
* Always build both device and simulator slices to ensure compatibility with all targets.
* For automation, consider creating a shell script to build device + simulator and create the XCFramework in one step.

---


# Usage
## 🚀 Features

- **Native iOS Integration**: Built as an XCFramework for easy integration into iOS projects
- **SwiftUI Support**: Modern SwiftUI-based payment interface
- **Secure Payment Processing**: HMAC-SHA256 signature generation for secure transactions
- **Real-time Payment Status**: Live payment status updates and callbacks
- **Customizable Configuration**: Flexible payment configuration options
- **Demo App Included**: Complete working example demonstrating integration

## 📋 Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## 🛠 Installation

### Option 1: XCFramework Integration

1. Download the `EsewWebToSDKV.xcframework` file
2. Add it to your Xcode project:
   - Drag the framework into your project
   - Ensure "Copy items if needed" is checked
   - Add to target dependencies

### Option 2: Source Integration

1. Clone this repository
2. Add the `EsewWebToSDKV` folder to your Xcode project
3. Import the framework in your Swift files

## 🎯 Quick Start

### Basic Integration

```swift
import EsewWebToSDKV
import SwiftUI

struct PaymentView: View {
    var body: some View {
        NavigationView {
            let config = ESewaPaymentConfig(
                amount: "100",
                taxAmount: "0",
                productServiceCharge: "0",
                productDeliveryCharge: "0",
                productCode: "EPAYTEST",
                successURL: "https://yourdomain.com/success",
                failureURL: "https://yourdomain.com/failure"
            )
            
            ESewaPaymentTestView(config: config)
        }
    }
}
```

### Advanced Configuration

```swift
let paymentConfig = ESewaPaymentConfig(
    amount: "500",                    // Base amount
    taxAmount: "50",                 // Tax amount
    productServiceCharge: "25",      // Service charge
    productDeliveryCharge: "10",     // Delivery charge
    productCode: "YOUR_PRODUCT_CODE", // Your product code
    successURL: "https://yourapp.com/payment/success",
    failureURL: "https://yourapp.com/payment/failure"
)
```

## 📚 API Reference

### ESewaPaymentConfig

Configuration struct for payment parameters.

```swift
public struct ESewaPaymentConfig {
    public let amount: String
    public let taxAmount: String
    public let productServiceCharge: String
    public let productDeliveryCharge: String
    public let productCode: String
    public let successURL: String
    public let failureURL: String
    
    // Computed property for total amount
    var totalAmount: String
    
    // Generate payment data with signature
    func generatePaymentData() -> [String: String]
}
```

### ESewaPaymentTestView

Main payment interface view.

```swift
public struct ESewaPaymentTestView: View {
    public init(config: ESewaPaymentConfig)
}
```

### ESewaSignatureGenerator

Handles secure signature generation for payment requests.

```swift
struct ESewaSignatureGenerator {
    static func generateSignature(totalAmount: String, transactionUUID: String, productCode: String) -> String
    static func generateTransactionUUID() -> String
}
```

## 🔧 Configuration

### Test Credentials

The framework includes test credentials for development:

- **eSewa ID**: 9806800001/2/3/4/5cc
- **Password**: Nepal@123
- **Token**: 123456

### Production Setup

For production use:

1. Replace test credentials with your actual eSewa merchant credentials
2. Update the `secretKey` in `ESewaSignatureGenerator.swift`
3. Configure proper success/failure URLs
4. Use your production product codes

## 🎨 Customization

### Custom Payment Interface

You can create custom payment interfaces by using the `CustomESewaWebView` directly:

```swift
CustomESewaWebView(
    postData: config.generatePaymentData(),
    url: esewaURL,
    isLoading: $isLoading,
    currentURL: $currentURL,
    onSuccess: { url in
        // Handle success
    },
    onFailure: { url in
        // Handle failure
    }
)
```

### Styling

The framework uses SwiftUI's native styling system. You can customize:

- Colors and fonts
- Layout and spacing
- Loading indicators
- Alert messages

## 📱 Demo App

The project includes a complete demo app (`EsewaFramworkDemoApp`) that demonstrates:

- Payment configuration
- Amount input
- Product code setup
- Payment processing
- Success/failure handling

To run the demo:

1. Open `EsewWebToSDKV.xcodeproj`
2. Select the `EsewaFramworkDemoApp` scheme
3. Build and run on simulator or device

## 🔒 Security Features

- **HMAC-SHA256 Signatures**: All payment requests are cryptographically signed
- **Transaction UUIDs**: Unique transaction identifiers for each payment
- **Secure Data Transmission**: POST requests with proper encoding
- **URL Validation**: Automatic success/failure URL detection

## 🐛 Troubleshooting

### Common Issues

1. **Payment Not Processing**
   - Verify your product code is correct
   - Check network connectivity
   - Ensure URLs are properly formatted

2. **Signature Errors**
   - Verify the secret key matches your eSewa configuration
   - Check that all required fields are included in the signature

3. **Build Errors**
   - Ensure iOS deployment target is 13.0+
   - Check that all required frameworks are linked

### Debug Mode

Enable debug logging by checking the console output. The framework logs:
- Transaction UUIDs
- Generated signatures
- Payment data
- URL navigation events

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For support and questions:

- Create an issue in this repository
- Check the demo app for implementation examples
- Review the eSewa documentation for payment gateway specifics

## 🔄 Version History

- **v1.0.0**: Initial release with basic payment integration
- Native SwiftUI interface
- HMAC signature generation
- Complete demo application

---

**Note**: This framework is designed for eSewa payment integration in Nepal. Ensure compliance with local payment regulations and eSewa's terms of service.

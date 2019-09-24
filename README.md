<p align="center">
    <img src="wombat_logo.png" alt="Wombat" title="Wombat">
</p>


[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Objective-C](https://img.shields.io/badge/Objective--C-compatible-blue)](https://developer.apple.com/documentation/objectivec)

# WombatAuth

iOS client SDK for DApps.

## Supported Actions
1. [**Authorize**](#authorize): Retrieve account details for an EOS account
2. [**Transfer**](#transfer): EOS transfer
3. [**Push**](#push): Push EOS transaction
4. [**Sign**](#sign): Request signature

## Installation
1. Add `WombatAuth.framework` into your Embedded Binaries.
2. Add the following 2 snippets into your `Info.plist`.

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- URL scheme to use when returning from Wombat to your app -->
            <string>wombat.$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        </array>
    </dict>
</array>
```

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <!-- URL scheme to use when launching Wombat from your app -->
    <string>wombat</string>
</array>
```

##### If your project is written in Objective-C
3. In project's **Build Settings** set **Always Embed Swift Standard Libraries** to **YES**.
4. Import the library by adding `#import <WombatAuth/WombatAuth-Swift.h>`.

## Usage
#### Register your app

Make sure your app is registered prior to executing any requests.

```swift
import WombatAuth

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WombatAuth.shared.registerApp(name: "App's Name", icon: appsIconURL)
        return true
    }
}
```

#### Response handler

In order to receive results you need to register an url handler in the `AppDelegate:application(_:open:options:)`.

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return WombatAuth.shared.application(open: url, options: options) { result in
        switch result {
        case .success(let action, let data):
            switch action {
            case .authorize:
                print(data["accountName"])
                print(data["publicKey"])
            case .pushTransaction:
                print(data["transactionID"])
            case .signTransaction:
                print(data["signature"])
           case .transfer:
               print(data["transactionID"])
           }
       case .error(let error):
           switch error {
           case .unknown(let errorMessage):
               print(errorMessage)
           default:
               break
           }
       case .userCancelled(let action):
           break
       }
    }
}

```

##### Objective-C
```objc
[WombatAuth.shared openURL: url options: options completionHandler: ^(WMResultObj *result) {
    WMActionType action = result.action; // WMActionTypeUnknown, WMActionTypeAuthorize, WMActionTypePushTransaction, WMActionTypeSignTransaction, WMActionTypeTransfer
    WMResultType resultType = result.type; // WMResultTypeSuccess, WMResultTypeError, WMResultTypeUserCancelled
    NSDictionary *data = result.data; // NSDictionary<NSString *,id>
}];
```

## Actions

#### Authorize
```swift
WombatAuth.shared.requestAuthorization()
```

#### Transfer
```swift
let transfer = WMTransfer(
    from: "account_name",
    to: "account_name_2",
    amount: 1,
    precision: 4,
    contract: "eosio.token",
    symbol: "EOS",
    memo: "Some memo"
)

WombatAuth.shared.requestTransfer(transfer)
```

#### Push
```swift
let transaction = WMTransaction(
    from: "account_name",
    actions: [
        .init(
            account: "eosio.token",
            name: "transfer",
            auth: [.init(actor: "account_name", permission: "owner")],
            data: [
                "from": "account_name",
                "to": "account_name_2",
                "quantity": "1 EOS",
                "memo": "Here you go"
            ]
        )
    ]
)

WombatAuth.shared.pushTransaction(transaction)
```

#### Sign
```swift
WombatAuth.shared.requestSignature(account: "account_name", data: "Some data")
```

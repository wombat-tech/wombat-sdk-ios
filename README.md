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

_You might encounter a problem while submitting your app to the App Store. This is due to a [bug in the App Store](http://www.openradar.me/radar?id=6409498411401216) itself. You can solve it by creating a new **Run Script Phase**, after the **Embed Frameworks** phase, in your app’s target’s **Build Phases**, and copying the script available [here](https://stackoverflow.com/a/30866648)._


Add the following 2 snippets into your `Info.plist`.

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

### Cocoapods
Add the following line to your Podfile and run `pod install`.

```ruby
pod 'WombatAuth'
```

### Manual
1. Download the latest version of the framework [here](https://github.com/wombat-tech/wombat-sdk-ios/releases).
2. Add `WombatAuth.framework` into your Embedded Binaries.

###### If your project is written in Objective-C
4. In project's **Build Settings** set **Always Embed Swift Standard Libraries** to **YES**.
5. Import the library by adding `#import <WombatAuth/WombatAuth-Swift.h>`.

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
    return WombatAuth.shared.application(open: url) { result in
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
       case .error(let action, let error):
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
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WombatAuth.shared openURL:url completionHandler:^(WMResultObj *result) {
        NSString *message = result.message; // "success" or an error message
        NSDictionary *data = result.data; // NSDictionary<NSString *,id>

        switch (result.type) {
            case WMResultTypeSuccess:
                switch (result.action) {
                    case WMActionTypeAuthorize:
                        // data[@"accountName"] - NSString
                        // data[@"publicKey"] - NSString
                        break;
                    case WMActionTypePushTransaction:
                        // data[@"transactionID"] - NSString
                        break;
                    case WMActionTypeSignTransaction:
                        // data[@"signature"] - NSString
                        break;
                    case WMActionTypeTransfer:
                        // data[@"transactionID"] - NSString
                        break;
                    case WMActionTypeUnknown:
                        break;
                }
            case WMResultTypeError:
                break;
            case WMResultTypeUserCancelled:
                break;
        }
    }];
}
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

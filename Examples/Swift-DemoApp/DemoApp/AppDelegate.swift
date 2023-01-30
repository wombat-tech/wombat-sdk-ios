import UIKit
import WombatAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: 1. Register your app
        // You can optionally also specify `chainID`. If omitted, the wallet will use the EOS blockchain as default
        WMAuth.shared.registerApp(
            name: "Demo App",
            icon: URL(string: "https://assets.website-files.com/5cde8c951beecf3604688a58/5d120b2cba030f78d70c7236_Wombat_logo_transparent-p-500.png")!,
            blockchain: .polygon
        )
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return WMAuth.shared.application(open: url) { result in
            switch result {
            case let .success(action, blockchain, data):
                switch action {
                case .authorize:
                    let message: String
                    if blockchain.isEvm {
                        let address = data["address"] as! String
                        message = "Public address is \(address)"
                    } else {
                        let accountName = data["accountName"] as! String
                        let publicKey = data["publicKey"] as! String
                        message = "Name: \(accountName)\nKey: \(publicKey)"
                    }
                    showAlert(title: "Auth", message: message)
                case .personalSignEVM:
                    let signedMessage = data["signedMessage"] as! String
                    showAlert(title: "Personal Sign", message: signedMessage)
                case .signTypedDataEVM:
                    let signedMessage = data["signedMessage"] as! String
                    showAlert(title: "Signed Typed Data", message: signedMessage)
                case .transactionEVM:
                    let transactionId = data["transactionID"] as! String
                    showAlert(title: "Transaction", message: transactionId)
                case .signEOSIO:
                    let signedMessage = data["signature"] as! String
                    showAlert(title: "Sign", message: signedMessage)
                case .transferEOSIO:
                    let transactionId = data["transactionID"] as! String
                    showAlert(title: "Transaction", message: transactionId)
                case .transactionEOSIO:
                    let transactionId = data["transactionID"] as! String
                    showAlert(title: "Transaction", message: transactionId)
                default:
                    break
                }
            case let .error(_, _, error):
                showAlert(title: "Error", message: error.localizedDescription)
            case .userCancelled:
                showAlert(title: "User cancelled")
            default:
                break
            }
        }
    }

    private func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}


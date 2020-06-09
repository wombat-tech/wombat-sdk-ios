import UIKit
import WombatAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: 1. Register your app
        // You can optionally also specify `chainID`. If omitted, the wallet will use the EOS blockchain as default
        WombatAuth.shared.registerApp(name: "Demo App", icon: URL(string: "https://assets.website-files.com/5cde8c951beecf3604688a58/5d120b2cba030f78d70c7236_Wombat_logo_transparent-p-500.png")!)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // MARK: 2. Handle responses
        return WombatAuth.shared.application(open: url) { (result: WombatAuth.RequestResult) in
            switch result {
            case .success(let action, let data):
                switch action {
                case .authorize:
                    let accountName = data["accountName"] as! String
                    let publicKey = data["publicKey"] as! String
                    showAlert(title: "Auth", message: "Name: \(accountName)\nKey: \(publicKey)")
                case .pushTransaction:
                    let transactionID = data["transactionID"] as! String
                    showAlert(title: "Push", message: transactionID)
                case .signData:
                    let signature = data["signature"] as! String
                    showAlert(title: "Sign", message: signature)
                case .transfer:
                    let transactionID = data["transactionID"] as! String
                    showAlert(title: "Transfer", message: transactionID)
                }

                dump(data)
            case .error(let action, let error):
                let actionType = (action == nil) ? "Unknown" : String(describing: action!)

                switch error {
                case .unknown(let errorMessage):
                    showAlert(title: "\(actionType) - Unknown Error", message: errorMessage ?? "N/A")
                case .invalidResponse:
                    showAlert(title: "\(actionType) - Invalid Response")
                }
            case .userCancelled(let action):
                showAlert(title: String(describing: action), message: "Cancelled by the user")
            }
        }
    }

    private func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}


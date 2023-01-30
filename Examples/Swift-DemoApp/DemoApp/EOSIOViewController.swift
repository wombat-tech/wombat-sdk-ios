import UIKit
import WombatAuth

class EOSIOViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        WMAuth.shared.registerApp(
            name: Constants.appName,
            icon: Constants.appIconURL,
            blockchain: .init(
                platform: .eosio,
                chainID: "73e4385a2708e6d7048834fbc1079f2fabb17b3c125b146af438971e90716c4d" // EOS - testnet
//                chainID: "f16b1833c747c43682f4386fca9cbb327929334a762755ebec17f6f23c9b8a12" // WAX - testnet
            )
        )
    }

    @IBAction func authorize() {
        try? WMAuth.shared.requestAuthorization()
    }

    @IBAction func sign() {
        try? WMAuth.shared.requestSignature(account: "cryptomarsel", data: "some data to sign")
    }

    @IBAction func transfer() {
        let sender = "{SENDER_ACCOUNT_NAME}"
        let receiver = "{RECEIVER_ACCOUNT_NAME}"
        let transfer = WMEOSIOTransfer(
            from: sender,
            to: receiver,
            amount: 1,
            precision: 4,
            contract: "eosio.token",
            symbol: "EOS",
            memo: "Some memo"
        )
        try? WMAuth.shared.requestTransfer(transfer)
    }

    @IBAction func push() {
        let sender = "{SENDER_ACCOUNT_NAME}"
        let receiver = "{RECEIVER_ACCOUNT_NAME}"
        let transaction = WMEOSIOTransaction(
            from: "cryptomarsel",
            actions: [
                .init(
                    account: "eosio.token",
                    name: "transfer",
                    auth: [.init(actor: sender, permission: "active")],
                    data: [
                        "from": sender,
                        "to": receiver,
                        "quantity": "1 EOS",
                        "memo": "Here you go"
                    ]
                )
            ]
        )
        try? WMAuth.shared.pushTransaction(transaction)
    }
}

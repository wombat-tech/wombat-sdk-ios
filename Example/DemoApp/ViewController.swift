import UIKit
import WombatAuth

class ViewController: UIViewController {
    @IBAction func authorize() {
        WombatAuth.shared.requestAuthorization()
    }

    @IBAction func transfer() {
        let transfer = WMTransfer(
            from: "aaaabbbbcccc",
            to: "xxxxyyyyzzzz",
            amount: 1,
            precision: 4,
            contract: "eosio.token",
            symbol: "EOS",
            memo: "Some memo"
        )

        WombatAuth.shared.requestTransfer(transfer)
    }

    @IBAction func sign() {
        WombatAuth.shared.requestSignature(account: "account", data: "some data to sign")
    }

    @IBAction func push() {
        let transaction = WMTransaction(
            from: "aaaabbbbcccc",
            actions: [
                .init(
                    account: "eosio.token",
                    name: "transfer",
                    auth: [.init(actor: "aaaabbbbcccc", permission: "active")],
                    data: [
                        "from": "aaaabbbbcccc",
                        "to": "xxxxyyyyzzzz",
                        "quantity": "1.3000 EOS",
                        "memo": "Here you go"
                    ]
                )
            ]
        )

        WombatAuth.shared.pushTransaction(transaction)
    }
}

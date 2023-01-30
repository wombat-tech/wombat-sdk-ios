//
//  EVMViewController.swift
//  DemoApp
//
//  Created by Marsel Tzatzos on 31/1/23.
//

import UIKit
import WombatAuth

class EVMViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        WMAuth.shared.registerApp(
            name: Constants.appName,
            icon: Constants.appIconURL,
            blockchain: .init(platform: .evm, chainID: "80001")
        )
    }

    @IBAction func authorize() {
        try? WMAuth.shared.requestAuthorization()
    }

    @IBAction func personalSign() {
        try? WMAuth.shared.personalSign(message: "Hello World!")
    }

    @IBAction func signTypedData_v4() {
        let data = """
            {
              "types": {
                  "EIP712Domain": [
                      {"name": "name", "type": "string"},
                      {"name": "version", "type": "string"},
                      {"name": "chainId", "type": "uint256"},
                      {"name": "verifyingContract", "type": "address"}
                  ],
                  "Person": [
                      {"name": "name", "type": "string"},
                      {"name": "wallet", "type": "bytes32"},
                      {"name": "age", "type": "int256"},
                      {"name": "paid", "type": "bool"}
                  ]
              },
              "primaryType": "Person",
              "domain": {
                  "name": "Person",
                  "version": "1",
                  "chainId": 1,
                  "verifyingContract": "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"
              },
              "message": {
                  "name": "alice",
                  "wallet": "0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB",
                  "age": 40,
                  "paid": true
                }
            }
        """.data(using: .utf8)!
        try? WMAuth.shared.signTypedData(data: data)
    }

    @IBAction func trasnfer() {
        let value = String(format:"%llx", 100_000_000_000_000_000)
        let sender = "0xc60Fa6D34C8A926E22791D7178F883Bd4cf2B312"
        let receiver = "0x7F4Ff6c65fB4a1211931b80d05062daDfB5480bD"
        try? WMAuth.shared.pushTransaction(
            WMEVMTransaction(
                from: sender,
                to: receiver,
                value: value,
                data: nil
            )
        )
    }

    @IBAction func transaction() {
        let sender = "0xc60Fa6D34C8A926E22791D7178F883Bd4cf2B312"
        let contract = "0x2d7882beDcbfDDce29Ba99965dd3cdF7fcB10A1e"
        let data = "a9059cbb0000000000000000000000007f4ff6c65fb4a1211931b80d05062dadfb5480bd000000000000000000000000000000000000000000000000016345785d8a0000".hexadecimal
        try? WMAuth.shared.pushTransaction(
            WMEVMTransaction(
                from: sender,
                to: contract,
                value: nil,
                data: data
            )
        )
    }
}

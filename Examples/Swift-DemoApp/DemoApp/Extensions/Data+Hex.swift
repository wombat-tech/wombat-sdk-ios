//
//  Data+Hex.swift
//  DemoApp
//
//  Created by Marsel Tzatzos on 31/1/23.
//

import Foundation

extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}

//
//  Date+Extensions.swift
//  PetIT
//
//  Created by Stephanie Ramirez on 3/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation

extension Date {
    // get an ISO timestamp
    static func getISOTimestamp() -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        let timestamp = isoDateFormatter.string(from: Date())
        return timestamp
    }
}

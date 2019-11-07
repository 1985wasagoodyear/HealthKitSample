//
//  Date+Utility.swift
//  HealthKitSample
//
//  Created by K Y on 11/6/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

extension Date {
    static func startOfCurrentDate() -> Date {
        //   Get the start of the day
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.startOfDay(for: Date())
        return date
    }
}

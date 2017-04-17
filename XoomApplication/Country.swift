//
//  Country.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import Foundation

/** 
 Country object
 - holds neccessary UI properties: CountryCode
 - persists to / loads from disk
 */
public struct Country {
    public let isoCode: CountryCode
    public let receiveCurrencyCode: String
    public let sendFxRate: Double
    public let feesChanged: Date
}

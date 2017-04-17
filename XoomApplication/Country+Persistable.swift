//
//  Country+Persistable.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import Foundation

extension Country: Persistable {
    public func save() -> [String:Any] {
        var dict: [String:Any] = ["isoCode":isoCode.rawValue ] //as NSString]
        
        if let currCode = properties.receiveCurrencyCode {
            dict["receiveCurrencyCode"] = currCode //as NSString
        }
        if let rate = properties.sendFxRate {
            dict["sendFxRate"] = NSNumber(value: rate)
        }
        if let date = properties.feesChanged {
            dict["feesChanged"] = date // as NSDate
        }
        return dict
    }
    
    public static func load(from object: [String:Any]) throws -> Country {
        guard let isoString = object["isoCode"] as? String,
            let isoCode = CountryCode(rawValue: isoString) else { throw PersistableError.unknownError }
        
        let currCode = object["receiveCurrencyCode"] as? String
        let rate = object["sendFxRate"] as? NSNumber
        let date = object["feesChanged"] as? Date
        
        return Country(isoCode, receiveCurrencyCode: currCode, sendFxRate: rate?.doubleValue, feesChanged: date)
    }
    
    /// last country viewed, saved to UserDefaults
    public static var last: Country? {
        get {
            guard let object = UserDefaults.standard.object(forKey: "com.Xoom.lastCountry") as? Country.PersistentObject else {
                return nil
            }
            return try? Country.load(from: object)
        }
        set {
            UserDefaults.standard.set(newValue?.save(), forKey: "com.Xoom.lastCountry")
        }
    }
}

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
public class Country {
    public let isoCode: CountryCode
    public private(set) var properties: LoadableProperties
    public var isLoaded: Bool {
        return properties.feesChanged != nil && properties.receivedCurrencyCode != nil && properties.feesChanged != nil
    }
    
    /// Properties loadable from API or Disk
    public class LoadableProperties {
        internal var receivedCurrencyCode: String?
        internal var sendFxRate: Double?
        internal var feesChanged: Date?
        
        internal init(_ receivedCurrencyCode: String?, sendFxRate: Double?, feesChanged: Date?) {
            self.receivedCurrencyCode = receivedCurrencyCode
            self.sendFxRate = sendFxRate
            self.feesChanged = feesChanged
        }
    }
    
    /// Initializer
    public init(_ code: CountryCode, receivedCurrencyCode: String? = nil, sendFxRate: Double? = nil, feesChanged: Date? = nil) {
        self.isoCode = code
        self.properties = LoadableProperties(receivedCurrencyCode, sendFxRate: sendFxRate, feesChanged: feesChanged)
    }
    
    /// Method to try to load properties
    public func load(_ notificationHandler: @escaping (LoadableProperties)->(), errorHandler: @escaping (Error)->()) {
        
        APIManager.create(for: self.isoCode) { (result:APIResult<Country.LoadableProperties, Error>) in
            switch result {
            case let .success(properties):
                self.properties = properties
                notificationHandler(properties)
            case let .error(error):
                errorHandler(error)
            }
        }
    }
}

extension Country: Equatable {
    public static func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.isoCode == rhs.isoCode
    }
}

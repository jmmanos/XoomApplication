//
//  Country.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import UIKit

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
    
    ///Visual properties
    public private(set) lazy var gradientProperties: GradientView.VisualProperties = {
        let randStart = CGFloat(arc4random() % 100)/100.0
        let randEnd = CGFloat(arc4random() % 100)/100.0
        let colors: [UIColor]
        
        switch self.isoCode {
        case .Argentina: colors = [UIColor.blue, .blue]
        case .Australia: colors = [.red, .blue] // 135
        case .Austria: colors = [.red, .white, .red] // red white red
        case .Bangladesh: colors = [.red, .green] // dark green
        case .Belgium: colors = [.black, .yellow, .red]
        case .Bolivia: colors = [.red, .yellow, .green]
        case .Brazil: colors = [.green , .yellow] // blue
        case .Canada: colors = [.red, .red] // white
        case .Chile: colors = [.blue, .red, .white]
        case .China: colors = [.yellow, .red]
        case .Colombia: colors = [.yellow, .blue, .red]
        case .CostaRica: colors = [.blue, .white, .red, .white, .blue] // dark blue
        case .Cyprus: colors = [.white, .orange, .white]
        case .DominicanRepublic: colors = [.blue, .red, .blue, .red]
        case .Ecuador: colors = [.yellow, .blue, .red]
        case .ElSalvador: colors = [.blue, .white, .blue]
        case .Estonia: colors = [.blue, .black]
        case .Finland: colors = [.white, .blue, .white]
        case .France: colors = [.blue, .white, .red]
        case .Germany: colors = [.black, .red, .yellow]
        case .Greece: colors = [.blue, .blue]
        case .Guatemala: colors = [.blue, .white, .blue]
        case .Guyana: colors = [.red, .yellow, .green, .green]
        case .Haiti: colors = [.blue, .red]
        case .Honduras: colors = [.blue, .white, .blue]
        case .HongKong: colors = [.red, .red]
        case .India: colors = [.orange, .white, .green]
        case .Ireland: colors = [.green, .white, .orange]
        case .Italy: colors = [.green, .white, .red]
        case .Jamaica: colors = [.green, .yellow, .black, .yellow, .green]
        case .Japan: colors = [.red, .red]
        case .Kenya: colors = [.black, .red, .green]
        case .Latvia: colors = [.red, .red, .white, .red, .red]
        case .Lithuania: colors = [.yellow, .green, .red]
        case .Luxembourg: colors = [.red, .white, .blue]
        case .Malta: colors = [.white, .white, .red, .red]
        case .Mexico: colors = [.green, .white, .red]
        case .Monaco: colors = [.white, .white, .red, .red]
        case .Nepal: colors = [.blue, .red, .red, .white, .red, .red, .blue]
        case .Netherlands: colors = [.red, .white, .blue]
        case .Nicaragua: colors = [.blue, .white, .blue]
        case .Nigeria: colors = [.green, .white, .green]
        case .Pakistan: colors = [.green, .green]
        case .Peru: colors = [.red, .white, .red]
        case .Philippines: colors = [.blue, .white, .yellow, .white, .red]
        case .Poland: colors = [ .lightGray, .red]
        case .Portugal: colors = [.green, .red, .red]
        case .SanMarino: colors = [.white, .blue]
        case .Singapore: colors = [.red, .white]
        case .Slovakia: colors = [.white, .blue, .blue, .red]
        case .Slovenia: colors = [.white, .blue, .red]
        case .SouthAfrica: colors = [.red, .green, .black, .green, .blue]
        case .Spain: colors = [.red, .yellow, .yellow, .red]
        case .SriLanka: colors = [.green, .orange, .red, .red]
        case .UnitedKingdom: colors = [.blue, .red, .blue]
        case .Uruguay: colors = [.yellow, .blue, .white, .blue]
        case .Vietnam: colors = [.red, .yellow, .red]
        }
        
        return GradientView.VisualProperties(colors: colors, startPoint: randStart, endPoint: randEnd)
    }()
    
    /// Initializer
    public init(_ code: CountryCode, receivedCurrencyCode: String? = nil, sendFxRate: Double? = nil, feesChanged: Date? = nil) {
        self.isoCode = code
        self.properties = LoadableProperties(receivedCurrencyCode, sendFxRate: sendFxRate, feesChanged: feesChanged)
    }
    
    /// Method to try to load properties
    public func load(_ handler: @escaping (APIResult<Country.LoadableProperties, Error>)->()) {
        
        APIManager.create(for: self.isoCode) { (result:APIResult<Country.LoadableProperties, Error>) in
            switch result {
            case let .success(properties):
                self.properties = properties
            case .error: break
            }
            handler(result)
        }
    }
}

extension Country: Equatable {
    public static func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.isoCode == rhs.isoCode
    }
}

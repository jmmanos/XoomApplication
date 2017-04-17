//
//  Country+DataSource.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

/// Data source for conutries
public struct CountryDataSource: DataSource {
    /// simple global instance
    public static let shared: CountryDataSource = CountryDataSource()
    
    /// total count of countries
    public let count: Int
    
    public func index(of element: Country) -> Int? {
        return allCountries.index(of: element)
    }
    
    public subscript(i: Int) -> Country? {
        guard i >= 0 && i < count else { return nil }
        return allCountries[i]
    }
    
    /// initialize count once for performance. Private init so shared is sole instance
    private init() {
        count = allCountries.count
    }
    
    /// All possible countries
    private var allCountries: [Country] = [ Country(.Argentina), Country(.Australia), Country(.Austria), Country(.Bangladesh), Country(.Belgium), Country(.Bolivia), Country(.Brazil), Country(.Canada), Country(.Chile), Country(.China), Country(.Colombia), Country(.CostaRica), Country(.Cyprus), Country(.DominicanRepublic), Country(.Ecuador), Country(.ElSalvador), Country(.Estonia), Country(.Finland), Country(.France), Country(.Germany), Country(.Greece), Country(.Guatemala), Country(.Guyana), Country(.Haiti), Country(.Honduras), Country(.HongKong), Country(.India), Country(.Ireland), Country(.Italy), Country(.Jamaica), Country(.Japan), Country(.Kenya), Country(.Latvia), Country(.Lithuania), Country(.Luxembourg), Country(.Malta), Country(.Mexico), Country(.Monaco), Country(.Nepal), Country(.Netherlands), Country(.Nicaragua), Country(.Nigeria), Country(.Pakistan), Country(.Peru), Country(.Philippines), Country(.Poland), Country(.Portugal), Country(.SanMarino), Country(.Singapore), Country(.Slovakia), Country(.Slovenia), Country(.SouthAfrica), Country(.Spain), Country(.SriLanka), Country(.UnitedKingdom), Country(.Uruguay), Country(.Vietnam)]
}

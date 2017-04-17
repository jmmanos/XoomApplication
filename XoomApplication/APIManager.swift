//
//  APIManager.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import Foundation

/// APIResponse container
public enum APIResult<S,E> {
    case success(S)
    case error(E)
}

/// Errors thrown by the API anager
public enum APIError: Error {
    /// URL couldn't be created
    case invalidURL
    
    case unknownError
    /// Date string parsing error
    case invalidDateString
}

/// Static class/method handling calls to Xoom API and parsing resulting data
public final class APIManager {
    /// Queue for parsing JSON and converting date
    private static let queue = DispatchQueue(label: "queue.XoomApp.API")
    
    /// date formatter handling the conversion of String -> Date
    private static let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return formatter
    }()
    /// Xoom API base countries url string
    private static let baseURL = "http://www.xoom.com/mapi/v1/countries/"
    
    
    /// given country code, fetch country
    public static func create(for code: CountryCode, returnQueue: DispatchQueue = .main, handler: @escaping (APIResult<Country.LoadableProperties,Error>)->()) {
        guard let url = URL(string: baseURL + code.rawValue) else {
            handler(APIResult.error(APIError.invalidURL)); return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            queue.async {
                let result: APIResult<Country.LoadableProperties, Error>
                
                do {
                    guard let data = data else { throw error ?? APIError.unknownError }
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    if let dataObject = json as? Dictionary<String,AnyObject>,
                        let dict = dataObject["data"] as? Dictionary<String,AnyObject>,
                        let fxArray = dict["fx"] as? Array<Dictionary<String,AnyObject>>,
                        let fx = fxArray.first,
                        let recCode = fx["receiveCurrencyCode"] as? String,
                        let fxRate = fx["sendFxRate"] as? Double,
                        let country = dict["country"] as? Dictionary<String,AnyObject>,
                        let cCode = country["countryCode"] as? String,
                        let countryCode = CountryCode(rawValue: cCode),
                        countryCode == code,
                        let feesChanged = country["feesChanged"] as? String {
                        
                        let feesChangedDate: Date
                        
                        if let referenceDate = APIManager.formatter.date(from: feesChanged) {
                            feesChangedDate = referenceDate
                        } else {
                            throw APIError.invalidDateString
                        }
                        
                        let properties = Country.LoadableProperties(recCode, sendFxRate: fxRate, feesChanged: feesChangedDate)
                        result = APIResult.success(properties)
                    } else {
                        throw APIError.unknownError
                    }
                } catch {
                    result = APIResult.error(error)
                }
                
                returnQueue.async {
                    handler(result)
                }
            }
        }
        task.resume()
    }
}

//
//  PersistableTests.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import XCTest
@testable import XoomApplication

class PersistableTests: XCTestCase {
    let testCountry = Country(CountryCode.Bangladesh, receiveCurrencyCode: "BDT", sendFxRate: 79.47, feesChanged: Date(timeIntervalSince1970: 0))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSave() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let dict = testCountry.save()
        
        let isoCode = dict["isoCode"]
        let currCode = dict["receiveCurrencyCode"]
        let rate = dict["sendFxRate"]
        let date = dict["feesChanged"]
        
        XCTAssertNotNil(isoCode, "ISO code should not be nil")
        XCTAssertNotNil(isoCode as? String, "ISO should be String")
        
        XCTAssertNotNil(currCode, "ReceiveCurrencyCode should not be nil")
        XCTAssertNotNil(currCode as? String, "ReceiveCurrencyCode should be String")
        
        XCTAssertNotNil(rate, "SendFxRate should not be nil")
        XCTAssertNotNil(rate as? NSNumber, "SendFxRate should be NSNumber")
        
        XCTAssertNotNil(date, "FeesChanged should not be nil")
        XCTAssertNotNil(date as? Date, "FeesChanged should be Date")
        
        XCTAssert((isoCode as! String) == "BD", "Save isoCode should be BD")
        XCTAssert((currCode as! String) == "BDT", "Save receiveCurrencyCode should be BDT")
        XCTAssertEqualWithAccuracy((rate as! NSNumber).doubleValue, 79.47, accuracy: Double.leastNormalMagnitude, "SenFxRate should be around 79.47")
        
        XCTAssert((date as! Date).timeIntervalSince1970 == 0, "Date.timeIntervalSince1970 should be 0")
    }
    
    func testLoad() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let isoCode = CountryCode.Bangladesh
        let currCode = "BDT"
        let rate = 79.47
        let date = Date(timeIntervalSince1970: 0)
        
        let dict: [String:Any] = ["isoCode":isoCode.rawValue, "receiveCurrencyCode":currCode, "sendFxRate":rate, "feesChanged":date]
        
        do {
            let country: Country = try Country.load(from: dict)
            let p = country.properties
            
            XCTAssertNotNil(p.receiveCurrencyCode, "ReceiveCurrencyCode should not be nil")
            XCTAssertNotNil(p.sendFxRate, "SendFxRate should not be nil")
            XCTAssertNotNil(p.feesChanged, "FeesChanged should not be nil")
            
            XCTAssert(p.receiveCurrencyCode == "BDT", "Save receiveCurrencyCode should be BDT")
            XCTAssertEqualWithAccuracy(p.sendFxRate!, 79.47, accuracy: Double.leastNormalMagnitude, "SenFxRate should be around 79.47")
            XCTAssert(p.feesChanged!.timeIntervalSince1970 == 0, "Date.timeIntervalSince1970 should be 0")
        } catch {
            XCTFail("Load shouldnt throw error: \(error)")
        }
    }
    
    func testLoadSaveHelper() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        Country.last = nil
        
        XCTAssertNil(Country.last, "No country saved")
        
        Country.last = testCountry
        
        if let lastCountry = Country.last {
            let p = lastCountry.properties
            
            XCTAssertNotNil(p.receiveCurrencyCode, "ReceiveCurrencyCode should not be nil")
            XCTAssertNotNil(p.sendFxRate, "SendFxRate should not be nil")
            XCTAssertNotNil(p.feesChanged, "FeesChanged should not be nil")
            
            XCTAssert(p.receiveCurrencyCode == "BDT", "Save receiveCurrencyCode should be BDT")
            XCTAssertEqualWithAccuracy(p.sendFxRate!, 79.47, accuracy: Double.leastNormalMagnitude, "SenFxRate should be around 79.47")
            XCTAssert(p.feesChanged!.timeIntervalSince1970 == 0, "Date.timeIntervalSince1970 should be 0")
        }
    }
    
}

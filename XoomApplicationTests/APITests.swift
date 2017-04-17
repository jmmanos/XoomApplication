//
//  APITests.swift
//  XoomApplication
//
//  Created by John Manos on 4/17/17.
//  Copyright © 2017 John Manos. All rights reserved.
//

import XCTest
@testable import XoomApplication

class APITests: XCTestCase {
    let testCountry = Country(CountryCode.Bangladesh)
    
    func testAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertFalse(testCountry.isLoaded, "Country should need to be loaded.")
        
        let exp = expectation(description: "API call.")
        
        testCountry.load { (result:APIResult<Country.LoadableProperties, Error>) in
            switch result {
            case let .success(p):
                XCTAssertNotNil(p.receiveCurrencyCode, "ReceiveCurrencyCode should not be nil")
                XCTAssertNotNil(p.sendFxRate, "SendFxRate should not be nil")
                XCTAssertNotNil(p.feesChanged, "FeesChanged should not be nil")
                
                XCTAssert(p.receiveCurrencyCode == "BDT", "Save receiveCurrencyCode should be BDT")
                XCTAssertEqualWithAccuracy(p.sendFxRate!, 79.47, accuracy: 1, "SenFxRate should be around 79.47")
                
                XCTAssertTrue(self.testCountry.isLoaded, "Country should be loaded now.")
                
                exp.fulfill()
            case let .error(error):
                XCTFail("API returned error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}

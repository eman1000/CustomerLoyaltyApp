//
//  CustomerLoyaltyAppTests.swift
//  CustomerLoyaltyAppTests
//
//  Created by Emmancipate Musemwa on 27/06/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import XCTest
@testable import CustomerLoyaltyApp

class CustomerLoyaltyAppTests: XCTestCase {
    
    var testController : MainPageViewController?
    
    override func setUp() {
        super.setUp()
        
        testController =  MainPageViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        testController = nil
    }
    
    func testConvertIntToString(){
    
    var expectedValue = 10
        var actualValue = testController?.convertStringToInt("10")
        
        XCTAssertEqual(expectedValue, actualValue!, "expected value \(expectedValue) is not equal to actual value \(actualValue)")
    
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}

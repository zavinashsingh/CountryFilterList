//
//  APIServiceTest.swift
//  ShellAssignmentTests
//
//  Created by Avinash Singh on 06/02/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import XCTest
@testable import ShellAssignment

class APIServiceTest: XCTestCase {
    var sessionUnderTest: URLSession!
    override func setUp() {
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        
    }

    override func tearDown() {
        sessionUnderTest = nil
    }

    func testValidCallToFetchCountries() {
        // given
        let promise = expectation(description: "Expectation Meet")
        APIService.shared.fetchCountries(searchText: "India") { (country) in
            XCTAssert(country.count > 0, "Country received")
            XCTAssert((country.first?.name?.contains("India"))!, "Correct Result Received")
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }

    func testValidCallToFetchSelectedCountries() {
        let promise = expectation(description: "Expectation Meet")
        APIService.shared.fetchCountries(searchText: "India") { (country) in
            XCTAssert(country.count > 0, "Country received")
            XCTAssert((country.first?.name?.contains("India"))!, "Correct Result Received")
            promise.fulfill()
        }
        waitForExpectations(timeout: 30)
    }
}

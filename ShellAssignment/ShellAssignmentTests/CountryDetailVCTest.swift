//
//  CountryDetailVCTest.swift
//  ShellAssignmentTests
//
//  Created by Avinash Singh on 06/02/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import XCTest
@testable import ShellAssignment

class CountryDetailVCTest: XCTestCase {
    var countryDetailVC = CountryDetailViewController(nibName: "CountryDetailViewController", bundle: nil)
    
    
    override func setUp() {
        countryDetailVC.country = Country(name: "India", flagURL: "https://restcountries.eu/data/ind.svg")
        countryDetailVC.loadViewIfNeeded()
    }

    override func tearDown() {
        countryDetailVC.country = nil
        super.tearDown()
    }

    func testSaveCurrentSelectedCountry(){
        let promise = expectation(description: "Expectation Meet")
        let countryDetail = CountryDetailsModel()
        countryDetail.callingCode = "91"
        countryDetail.capital = "New Delhi"
        countryDetail.currencies  =  " Indian Rupee"
        countryDetail.languages = "Hindi, English"
        countryDetail.name =  "India"
        countryDetail.region = "Asia"
        countryDetail.subRegion = "Southern Asia"
        countryDetail.timezones = "UTC+5:30"
        countryDetail.flagURL = "https://restcountries.eu/data/ind.svg"
        countryDetailVC.countryDetail = countryDetail
        countryDetailVC.updateView(countryDetail: countryDetail)
        countryDetailVC.save()
        if countryDetailVC.readFromCoreData(countryName: "India"){
            promise.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

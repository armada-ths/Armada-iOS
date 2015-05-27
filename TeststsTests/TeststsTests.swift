//
//  TeststsTests.swift
//  TeststsTests
//
//  Created by Sami Purmonen on 14/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit
import XCTest

class TeststsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCompaniesFromServer() {
        let companies = DataDude().companiesFromServer()!
        XCTAssert(companies.count == 150)
        XCTAssert(companies[0].name == "ACAD-International AB")
    }
    
    func testEventsFromServer() {
        let events = DataDude().eventsFromServer()!
        println("There are \(events.count) events")
        //XCTAssert(events.count == 6)
        //XCTAssert(events[0].title == "Armada run")
    }
    func testNewsFromServer() {
        let news = DataDude().newsFromServer()!
        println("There are \(news.count) news")
        XCTAssert(!news.isEmpty)
        XCTAssert(news[0].title == "The application is now closed")
    }
    
    func testParsingCompaniesFromJson() {
        let json: AnyObject = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSBundle(forClass: self.dynamicType).URLForResource("companies", withExtension: "json")!)!, options: nil, error: nil)!
        let companies = DataDude().companiesFromJson(json)
        XCTAssert(companies.count == 150)
        XCTAssert(companies[0].name == "ACAD-International AB")
    }

    func testParsingEventsFromJson() {
        let json: AnyObject = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSBundle(forClass: self.dynamicType).URLForResource("events", withExtension: "json")!)!, options: nil, error: nil)!
        let companies = DataDude().eventsFromJson(json)
        //XCTAssert(companies.count == 6)
        //XCTAssert(companies[0].title == "Armada run")
    }
    
    func testParsingNewsFromJson() {
        let json: AnyObject = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSBundle(forClass: self.dynamicType).URLForResource("news", withExtension: "json")!)!, options: nil, error: nil)!
        let companies = DataDude().newsFromJson(json)
        XCTAssert(!companies.isEmpty)
        XCTAssert(companies[0].title == "The application is now closed")
    }
}
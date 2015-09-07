//
//  VolumeFormatterTest.swift
//  UnitFormatters
//
//  Created by John Chang on 07/09/15.
//  Copyright © 2015 John Chang. All rights reserved.
//

import XCTest

class VolumeFormatterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        NSUserDefaults.standardUserDefaults().removeVolatileDomainForName(NSArgumentDomain)

        super.tearDown()
    }
    
    func testShortUnitStyle_en_Metric() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        
        let volumeFormatter = VolumeFormatter()
        volumeFormatter.unitStyle = .Short
        
        let zeroLString = volumeFormatter.stringFromLiters(0.0)
        XCTAssertEqual(zeroLString, "0 L")
        
        let oneLString = volumeFormatter.stringFromLiters(1.0)
        XCTAssertEqual(oneLString, "1 L")
        
        let manyLString = volumeFormatter.stringFromLiters(123.4)
        XCTAssertEqual(manyLString, "123,4 L")
    }
    
    func testLongUnitStyle_en_Metric() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        
        let volumeFormatter = VolumeFormatter()
        volumeFormatter.unitStyle = .Long
        
        let zeroLString = volumeFormatter.stringFromLiters(0.0)
        XCTAssertEqual(zeroLString, "0 liters")
        
        let oneLString = volumeFormatter.stringFromLiters(1.0)
        XCTAssertEqual(oneLString, "1 liter")
        
        let manyLString = volumeFormatter.stringFromLiters(123.4)
        XCTAssertEqual(manyLString, "123,4 liters")
    }
 
    func testMediumUnitStyle_en_US() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_US"], forName: NSArgumentDomain)
        
        let volumeFormatter = VolumeFormatter()
        volumeFormatter.unitStyle = .Medium
        
        let zeroLString = volumeFormatter.stringFromLiters(0.0)
        XCTAssertEqual(zeroLString, "0 cups")
        
//        let oneFlOzUSString = volumeFormatter.stringFromLiters(0.0295735)
//        XCTAssertEqual(oneFlOzUSString, "1 fl oz")
        let oneCupUSString = volumeFormatter.stringFromLiters(0.236588)
        XCTAssertEqual(oneCupUSString, "1 cup")

        let oneLString = volumeFormatter.stringFromLiters(1.0)
        XCTAssertEqual(oneLString, "4.227 cups")
        
//        let manyLString = volumeFormatter.stringFromLiters(123.4)
//        XCTAssertEqual(manyLString, "4,172.65 fl oz")
    }

    func testLongUnitStyle_en_US() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_US"], forName: NSArgumentDomain)
        
        let volumeFormatter = VolumeFormatter()
        volumeFormatter.unitStyle = .Long
        
        let zeroLString = volumeFormatter.stringFromLiters(0.0)
        XCTAssertEqual(zeroLString, "0 US cups")
        
        let oneCupUSString = volumeFormatter.stringFromLiters(0.236588)
        XCTAssertEqual(oneCupUSString, "1 US cup")

        let oneLString = volumeFormatter.stringFromLiters(1.0)
        XCTAssertEqual(oneLString, "4.227 US cups")
    }

}

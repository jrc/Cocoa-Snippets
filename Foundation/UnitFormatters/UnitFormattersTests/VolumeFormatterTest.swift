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
    
    
    // MARK: -

    func testShortUnitStyle_en_SE() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        
        let volumeFormatter = VolumeFormatter()
        volumeFormatter.unitStyle = .Short
        
        let mL_zero_String = volumeFormatter.stringFromLiters(0.0)
        XCTAssertEqual(mL_zero_String, "0 mL")
        
        let cL_one_String = volumeFormatter.stringFromLiters(0.01)
        XCTAssertEqual(cL_one_String, "1 cL")

        let cL_many_String = volumeFormatter.stringFromLiters(0.02)
        XCTAssertEqual(cL_many_String, "2 cL")

        let dL_one_String = volumeFormatter.stringFromLiters(0.1)
        XCTAssertEqual(dL_one_String, "1 dL")

        let dL_many_String = volumeFormatter.stringFromLiters(0.2)
        XCTAssertEqual(dL_many_String, "2 dL")

        let L_one_String = volumeFormatter.stringFromLiters(1.0)
        XCTAssertEqual(L_one_String, "1 L")
        
        let L_many_String = volumeFormatter.stringFromLiters(123.4)
        XCTAssertEqual(L_many_String, "123,4 L")
    }

    func testMediumUnitStyle_en_SE() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        
        let volumeFormatter = VolumeFormatter()
        volumeFormatter.unitStyle = .Medium
        
        let mL_zero_String = volumeFormatter.stringFromLiters(0.0)
        XCTAssertEqual(mL_zero_String, "0 mL")
        
        let cL_one_String = volumeFormatter.stringFromLiters(0.01)
        XCTAssertEqual(cL_one_String, "1 cL")
        
        let cL_many_String = volumeFormatter.stringFromLiters(0.02)
        XCTAssertEqual(cL_many_String, "2 cL")
        
        let dL_one_String = volumeFormatter.stringFromLiters(0.1)
        XCTAssertEqual(dL_one_String, "1 dL")
        
        let dL_many_String = volumeFormatter.stringFromLiters(0.2)
        XCTAssertEqual(dL_many_String, "2 dL")
        
        let L_one_String = volumeFormatter.stringFromLiters(1.0)
        XCTAssertEqual(L_one_String, "1 L")
        
        let L_many_String = volumeFormatter.stringFromLiters(123.4)
        XCTAssertEqual(L_many_String, "123,4 L")
    }

    func testLongUnitStyle_en_SE() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        
        let volumeFormatter = VolumeFormatter()
        volumeFormatter.unitStyle = .Long
        
        let mL_zero_String = volumeFormatter.stringFromLiters(0.0)
        XCTAssertEqual(mL_zero_String, "0 milliliters")
        
        let cL_one_String = volumeFormatter.stringFromLiters(0.01)
        XCTAssertEqual(cL_one_String, "1 centiliter")
        
        let cL_many_String = volumeFormatter.stringFromLiters(0.02)
        XCTAssertEqual(cL_many_String, "2 centiliters")
        
        let dL_one_String = volumeFormatter.stringFromLiters(0.1)
        XCTAssertEqual(dL_one_String, "1 deciliter")
        
        let dL_many_String = volumeFormatter.stringFromLiters(0.2)
        XCTAssertEqual(dL_many_String, "2 deciliters")
        
        let L_one_String = volumeFormatter.stringFromLiters(1.0)
        XCTAssertEqual(L_one_String, "1 liter")
        
        let L_many_String = volumeFormatter.stringFromLiters(123.4)
        XCTAssertEqual(L_many_String, "123,4 liters")
    }
 
    
    // MARK: -

    func testMediumUnitStyle_en_US() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_US"], forName: NSArgumentDomain)
        
        let volumeFormatter = VolumeFormatter()
        volumeFormatter.unitStyle = .Medium
        
        let zeroLString = volumeFormatter.stringFromLiters(0.0)
        XCTAssertEqual(zeroLString, "0 fluid ounces")
        
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
        XCTAssertEqual(zeroLString, "0 US fluid ounces")
        
        let oneCupUSString = volumeFormatter.stringFromLiters(0.236588)
        XCTAssertEqual(oneCupUSString, "1 US cup")

        let oneLString = volumeFormatter.stringFromLiters(1.0)
        XCTAssertEqual(oneLString, "4.227 US cups")
    }

}

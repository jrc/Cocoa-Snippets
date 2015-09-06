//
//  TemperatureFormatterTest.swift
//  TemperatureFormatterTest
//
//  Created by John Chang on 06/09/15.
//  Copyright © 2015 John Chang. All rights reserved.
//

import XCTest

class TemperatureFormatterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShortUnitStyle_EnglishUS() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_US"], forName: NSArgumentDomain)
        let temperatureFormatter = TemperatureFormatter()
        temperatureFormatter.unitStyle = .Short
        
        let zeroDegCString = temperatureFormatter.stringFromCelsius(0.0)
        XCTAssertEqual(zeroDegCString, "32°F")
        
        let oneDegCString = temperatureFormatter.stringFromCelsius(1.0)
        XCTAssertEqual(oneDegCString, "33.8°F")
        
        let manyDegCString = temperatureFormatter.stringFromCelsius(123.4)
        XCTAssertEqual(manyDegCString, "254.12°F")
    }
    
    func testMediumUnitStyle_EnglishUS() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_US"], forName: NSArgumentDomain)
        let temperatureFormatter = TemperatureFormatter()
        temperatureFormatter.unitStyle = .Medium
        
        let zeroDegCString = temperatureFormatter.stringFromCelsius(0.0)
        XCTAssertEqual(zeroDegCString, "32°F")
        
        let oneDegCString = temperatureFormatter.stringFromCelsius(1.0)
        XCTAssertEqual(oneDegCString, "33.8°F")
        
        let manyDegCString = temperatureFormatter.stringFromCelsius(123.4)
        XCTAssertEqual(manyDegCString, "254.12°F")
    }
    
    func testLongUnitStyle_EnglishUS() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_US"], forName: NSArgumentDomain)
        let temperatureFormatter = TemperatureFormatter()
        temperatureFormatter.unitStyle = .Long
        
        let zeroDegCString = temperatureFormatter.stringFromCelsius(0.0)
        XCTAssertEqual(zeroDegCString, "32 degrees Fahrenheit")
        
        let oneDegCString = temperatureFormatter.stringFromCelsius(1.0)
        XCTAssertEqual(oneDegCString, "33.8 degrees Fahrenheit")

        let oneDegFString = temperatureFormatter.stringFromCelsius(-17.2222222)
        XCTAssertEqual(oneDegFString, "1 degree Fahrenheit")

        let manyDegCString = temperatureFormatter.stringFromCelsius(123.4)
        XCTAssertEqual(manyDegCString, "254.12 degrees Fahrenheit")
    }

    func testShortUnitStyle_EnglishMetric() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        let temperatureFormatter = TemperatureFormatter()
        temperatureFormatter.unitStyle = .Short
        
        let zeroDegCString = temperatureFormatter.stringFromCelsius(0.0)
        XCTAssertEqual(zeroDegCString, "0°C")
        
        let oneDegCString = temperatureFormatter.stringFromCelsius(1.0)
        XCTAssertEqual(oneDegCString, "1°C")

        let manyDegCString = temperatureFormatter.stringFromCelsius(123.4)
        XCTAssertEqual(manyDegCString, "123,4°C")
    }

    func testMediumUnitStyle_EnglishMetric() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        let temperatureFormatter = TemperatureFormatter()
        temperatureFormatter.unitStyle = .Medium
        
        let zeroDegCString = temperatureFormatter.stringFromCelsius(0.0)
        XCTAssertEqual(zeroDegCString, "0°C")
        
        let oneDegCString = temperatureFormatter.stringFromCelsius(1.0)
        XCTAssertEqual(oneDegCString, "1°C")
        
        let manyDegCString = temperatureFormatter.stringFromCelsius(123.4)
        XCTAssertEqual(manyDegCString, "123,4°C")
    }
    
    func testLongUnitStyle_EnglishMetric() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        let temperatureFormatter = TemperatureFormatter()
        temperatureFormatter.unitStyle = .Long
        
        let zeroDegCString = temperatureFormatter.stringFromCelsius(0.0)
        XCTAssertEqual(zeroDegCString, "0 degrees Celsius")

        let oneDegCString = temperatureFormatter.stringFromCelsius(1.0)
        XCTAssertEqual(oneDegCString, "1 degree Celsius")

        let manyDegCString = temperatureFormatter.stringFromCelsius(123.4)
        XCTAssertEqual(manyDegCString, "123,4 degrees Celsius")
    }
    
//    func testDecimal() {
//        let temperatureFormatter = TemperatureFormatter()
//        temperatureFormatter.numberFormatter.numberStyle = .Short
//        
//        let zeroDegCString = temperatureFormatter.stringFromCelsius(0.0)
//        XCTAssertEqual(zeroDegCString, "0°C")
//        
//        let oneDegCString = temperatureFormatter.stringFromCelsius(1.0)
//        XCTAssertEqual(oneDegCString, "1°C")
//        
//        let manyDegCString = temperatureFormatter.stringFromCelsius(123.4)
//        XCTAssertEqual(manyDegCString, "123°C")
//    }
    

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}

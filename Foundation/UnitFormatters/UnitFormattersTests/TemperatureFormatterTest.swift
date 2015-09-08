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
        NSUserDefaults.standardUserDefaults().removeVolatileDomainForName(NSArgumentDomain)

        super.tearDown()
    }
    
    
    // MARK: -

    func testShortUnitStyle_en_SE() {
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

    func testMediumUnitStyle_en_SE() {
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
    
    func testLongUnitStyle_en_SE() {
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
    
    func testKelvin_en_SE() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_SE"], forName: NSArgumentDomain)
        
        let temperatureFormatter = TemperatureFormatter()
        
        let zeroDegCString = temperatureFormatter.stringFromValue(0.0, unit: .Kelvin)
        XCTAssertEqual(zeroDegCString, "0 K")
        
        let oneDegCString = temperatureFormatter.stringFromValue(1.0, unit: .Kelvin)
        XCTAssertEqual(oneDegCString, "1 K")
        
        let manyDegCString = temperatureFormatter.stringFromValue(123.4, unit: .Kelvin)
        XCTAssertEqual(manyDegCString, "123,4 K")
    }

    
    // MARK: -

    func testShortUnitStyle_en_US() {
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
    
    func testMediumUnitStyle_en_US() {
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
    
    func testLongUnitStyle_en_US() {
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
    
    func testKelvin_en_US() {
        NSUserDefaults.standardUserDefaults().setVolatileDomain(["AppleLocale" : "en_US"], forName: NSArgumentDomain)

        let temperatureFormatter = TemperatureFormatter()

        let zeroDegCString = temperatureFormatter.stringFromValue(0.0, unit: .Kelvin)
        XCTAssertEqual(zeroDegCString, "0 K")
        
        let oneDegCString = temperatureFormatter.stringFromValue(1.0, unit: .Kelvin)
        XCTAssertEqual(oneDegCString, "1 K")
        
        let manyDegCString = temperatureFormatter.stringFromValue(123.4, unit: .Kelvin)
        XCTAssertEqual(manyDegCString, "123.4 K")
    }
    
}

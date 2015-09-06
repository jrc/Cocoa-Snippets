//
//  TemperatureFormatter.swift
//  TempFormat
//
//  Created by John Chang on 06/09/15.
//  Copyright © 2015 John Chang. All rights reserved.
//

import Foundation

public enum TemperatureFormatterUnit : Int {
    case Celsius
    case Fahrenheit
    case Kelvin
}

class TemperatureFormatter: NSFormatter {
    
    
    @NSCopying var numberFormatter: NSNumberFormatter! // default is NSNumberFormatter with NSNumberFormatterDecimalStyle
    var unitStyle: NSFormattingUnitStyle // default is NSFormattingUnitStyleMedium
    
    
    override init() {
        numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        unitStyle = .Medium
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        unitStyle = .Medium
        super.init(coder: aDecoder)
    }
    
    override func stringForObjectValue(obj: AnyObject) -> String?
    {
        if let string = numberFormatter.stringForObjectValue(obj) {
            return string + "°"
        }
        
        return nil
    }
    
    func stringFromValue(value: Double, unit: TemperatureFormatterUnit) -> String
    {
        /*
         "In normal use, it is better to represent degrees Celsius “°C” with a sequence of U+00B0 DEGREE SIGN + U+0043 LATIN CAPITAL LETTER C, rather than U+2103 DEGREE CELSIUS."
         "To conclude, it is acceptable and recommendable to use normal Latin letters as SI unit symbols, such as “K” for kelvin."
         https://www.cs.tut.fi/~jkorpela/chars/si.html
        */
        var unitString: String
        switch unit {
        case .Celsius:
            switch unitStyle {
            case .Short:
                unitString = "C"
            case .Medium:
                unitString = "°C"
            case .Long:
                unitString = "degrees Celsius"
            }
        case .Fahrenheit:
            switch unitStyle {
            case .Short:
                unitString = "F"
            case .Medium:
                unitString = "°F"
            case .Long:
                unitString = "degrees Fahrenheit"
            }
        case .Kelvin:
            switch unitStyle {
            case .Short:
                unitString = "K"
            case .Medium:
                unitString = "K"
            case .Long:
                unitString = "degrees Kelvin"
            }
        }
        
        if let string = numberFormatter.stringForObjectValue(value) {
            return string + unitString
        }
        return ""
    }
    
}


import HealthKit

extension TemperatureFormatter {
    
    class func temperatureFormatterUnitFromUnit(unit: HKUnit) -> TemperatureFormatterUnit
    {
        if unit == HKUnit.degreeCelsiusUnit() {
            return .Celsius
        }
        else if unit == HKUnit.degreeFahrenheitUnit() {
            return .Fahrenheit
        }
        else if unit == HKUnit.kelvinUnit() {
            return .Kelvin
        }
        
        NSException.raise(NSInvalidArgumentException, format: "No mapping for unit %@ to TemperatureFormatterUnit", arguments: getVaList([unit.unitString]))
        return .Celsius
    }
    
}

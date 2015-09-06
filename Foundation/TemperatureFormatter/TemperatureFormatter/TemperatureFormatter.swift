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

        // for unit testing
        if let localeIdentifier = NSUserDefaults.standardUserDefaults().volatileDomainForName(NSArgumentDomain)["AppleLocale"] as? String {
            numberFormatter.locale = NSLocale(localeIdentifier: localeIdentifier)
        }
        
        unitStyle = .Medium
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        unitStyle = .Medium
        super.init(coder: aDecoder)
    }
    
    override func stringForObjectValue(obj: AnyObject) -> String? {
        if let value = obj as? Double {
            return stringFromCelsius(value)
        }
        return nil
    }
    
    // No parsing is supported. This method will return NO.
    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        return false
    }

    
    private func localizedNumberStringAndUnitStringFromValue(value: Double, unit: TemperatureFormatterUnit) -> (String, String) {
        let numberString = numberFormatter.stringForObjectValue(value)!
        let unitString: String
        
        switch unit {
        case .Celsius:
            switch unitStyle {
            case .Short, .Medium:
                unitString = NSLocalizedString("°C", comment: "degrees Celsius NSFormattingUnitStyleShort")
            case .Long:
                if numberString == "1" {
                    unitString = NSLocalizedString("degree Celsius", comment: "degree Celsius NSFormattingUnitStyleLong")
                }
                else {
                    unitString = NSLocalizedString("degrees Celsius", comment: "degrees Celsius NSFormattingUnitStyleLong")
                }
            }
        case .Fahrenheit:
            switch unitStyle {
            case .Short, .Medium:
                unitString = NSLocalizedString("°F", comment: "degrees Fahrenheit NSFormattingUnitStyleShort")
            case .Long:
                if numberString == "1" {
                    unitString = NSLocalizedString("degree Fahrenheit", comment: "degree Fahrenheit NSFormattingUnitStyleLong")
                }
                else {
                    unitString = NSLocalizedString("degrees Fahrenheit", comment: "degrees Fahrenheit NSFormattingUnitStyleLong")
                }
            }
        case .Kelvin:
            switch unitStyle {
            case .Short, .Medium:
                unitString = NSLocalizedString("K", comment: "Kelvin NSFormattingUnitStyleShort")
            case .Long:
                unitString = NSLocalizedString("Kelvin", comment: "Kelvin NSFormattingUnitStyleLong")
            }
        }
        
        return (numberString, unitString)
    }
    
    private func localeAppropriateValueAndUnitFromCelsius(numberInCelsius: Double) -> (Double, TemperatureFormatterUnit) {
        var locale = NSLocale.autoupdatingCurrentLocale()
        // for unit testing
        if let localeIdentifier = NSUserDefaults.standardUserDefaults().volatileDomainForName(NSArgumentDomain)["AppleLocale"] as? String {
            locale = NSLocale(localeIdentifier: localeIdentifier)
        }
        
        if locale.objectForKey(NSLocaleUsesMetricSystem)?.boolValue == true {
            return (numberInCelsius, .Celsius)
        }
        else {
            // Convert C to F
            let numberInFahrenheit = (numberInCelsius * 9/5) + 32
            
            return (numberInFahrenheit, .Fahrenheit)
        }
    }
    

    // Format a combination of a number and an unit to a localized string.
    // e.g. "100°C", "1 degree Celsius", "32 degrees Fahrenheit"
    func stringFromValue(value: Double, unit: TemperatureFormatterUnit) -> String {
        let (numberString, unitString) = localizedNumberStringAndUnitStringFromValue(value, unit: unit)
        
        if unitString.characters.first == "°" {
            return numberString + unitString
        }
        else {
            return numberString + " " + unitString
        }
    }
    
    // Format a number in Celsius to a localized string with the locale-appropriate unit and an appropriate scale (e.g. 100°C = 212°F in the US locale).
    func stringFromCelsius(numberInCelsius: Double) -> String {
        let (value, unit) = localeAppropriateValueAndUnitFromCelsius(numberInCelsius)
        
        return stringFromValue(value, unit: unit)
    }
    
    // Return a localized string of the given unit, and if the unit is singular or plural is based on the given number.
    // e.g. "°C", "degree Celsius", "degrees Fahrenheit"
    func unitStringFromValue(value: Double, unit: TemperatureFormatterUnit) -> String {
        let (_, unitString) = localizedNumberStringAndUnitStringFromValue(value, unit: unit)
        
        return unitString
    }

    // Return the locale-appropriate unit, the same unit used by -stringFromCelsius:.
    func unitStringFromCelsius(numberInCelsius: Double, usedUnit unitp: UnsafeMutablePointer<TemperatureFormatterUnit>) -> String {
        let (value, unit) = localeAppropriateValueAndUnitFromCelsius(numberInCelsius)
        
        if unitp != nil {
            unitp.memory = unit
        }
        return unitStringFromValue(value, unit: unit)
    }

}


//import HealthKit
//
//extension TemperatureFormatter {
//    
//    class func temperatureFormatterUnitFromUnit(unit: HKUnit) -> TemperatureFormatterUnit
//    {
//        if unit == HKUnit.degreeCelsiusUnit() {
//            return .Celsius
//        }
//        else if unit == HKUnit.degreeFahrenheitUnit() {
//            return .Fahrenheit
//        }
//        else if unit == HKUnit.kelvinUnit() {
//            return .Kelvin
//        }
//        
//        NSException.raise(NSInvalidArgumentException, format: "No mapping for unit %@ to TemperatureFormatterUnit", arguments: getVaList([unit.unitString]))
//        return .Celsius
//    }
//    
//}

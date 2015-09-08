//
//  TemperatureFormatter.swift
//  TempFormat
//
//  Created by John Chang on 06/09/15.
//  Copyright © 2015 John Chang. All rights reserved.
//

import Foundation

public enum TemperatureFormatterUnit : Int { // values based on HKUnit
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
    
    
    // MARK: -
    
    // Format a combination of a number and an unit to a localized string.
    // Output: e.g. "100°C", "1 degree Celsius", "32 degrees Fahrenheit"
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
    // Output: e.g. "°C", "degree Celsius", "degrees Fahrenheit"
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
    
    
    // MARK: - Private
    
    private func localizedNumberStringAndUnitStringFromValue(value: Double, unit: TemperatureFormatterUnit) -> (String, String) {
        let numberString = numberFormatter.stringForObjectValue(value)!
        
        let unitString: String // values based on HKUnit.unitString
        switch unit {
        case .Celsius:
            unitString = "degC"
        case .Fahrenheit:
            unitString = "degF"
        case .Kelvin:
            unitString = "K"
        }
        
        let unitStyleString: String
        switch unitStyle {
        case .Short:
            unitStyleString = "short"
        case .Medium:
            unitStyleString = "medium"
        case .Long:
            unitStyleString = "long"
        }
        
        let variant = (numberString == "1") ? "one" : "many"
        
        var localizedUnitString: String
            
        var key = NSString(format: "%@-%@-%@", unitString, unitStyleString, variant) as String
        localizedUnitString = NSLocalizedString(key, tableName: String(self.dynamicType), comment: "")
        
        if localizedUnitString == key { // not found
            key = NSString(format: "%@-%@", unitString, unitStyleString) as String
            localizedUnitString = NSLocalizedString(key, tableName: String(self.dynamicType), comment: "")
        }
        
        if localizedUnitString == key { // not found
            key = NSString(format: "%@", unitString) as String
            localizedUnitString = NSLocalizedString(key, tableName: String(self.dynamicType), comment: "")
        }
        
        return (numberString, localizedUnitString)
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
    
}

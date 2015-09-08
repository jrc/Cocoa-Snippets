//
//  VolumeFormatter.swift
//  UnitFormatters
//
//  Created by John Chang on 07/09/15.
//  Copyright © 2015 John Chang. All rights reserved.
//

import Foundation

public enum VolumeFormatterUnit : Int { // values based on HKUnit
    
    case Milliliter
    case Centiliter
    case Deciliter
    case Liter
    case FluidOunceUS
    case FluidOunceImperial
    case PintUS
    case PintImperial
    case CupUS
    case CupImperial
}

class VolumeFormatter: NSFormatter {
    
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
            return stringFromLiters(value)
        }
        return nil
    }
    
    // No parsing is supported. This method will return NO.
    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        return false
    }
    
    
    // MARK: -

    // Format a combination of a number and an unit to a localized string.
    // Output: e.g. "100 L", "1 liter", "12 fluid ounces"
    func stringFromValue(value: Double, unit: VolumeFormatterUnit) -> String {
        let (numberString, unitString) = localizedNumberStringAndUnitStringFromValue(value, unit: unit)
        
        return numberString + " " + unitString
    }
    
    // Format a number in Liter to a localized string with the locale-appropriate unit and an appropriate scale (e.g. 1 L = 33.814 fl oz in the US locale).
    func stringFromLiters(numberInLiters: Double) -> String {
        let (value, unit) = localeAppropriateValueAndUnitFromLiter(numberInLiters)
        
        return stringFromValue(value, unit: unit)
    }
    
    // Return a localized string of the given unit, and if the unit is singular or plural is based on the given number.
    // Output: e.g. "L", "liter", "liters"
    func unitStringFromValue(value: Double, unit: VolumeFormatterUnit) -> String {
        let (_, unitString) = localizedNumberStringAndUnitStringFromValue(value, unit: unit)
        
        return unitString
    }
    
    // Return the locale-appropriate unit, the same unit used by -stringFromLiters:.
    func unitStringFromLiters(numberInLiters: Double, usedUnit unitp: UnsafeMutablePointer<VolumeFormatterUnit>) -> String {
        let (value, unit) = localeAppropriateValueAndUnitFromLiter(numberInLiters)
        
        if unitp != nil {
            unitp.memory = unit
        }
        return unitStringFromValue(value, unit: unit)
    }
    
    
    // MARK: - Private

    private func localizedNumberStringAndUnitStringFromValue(value: Double, unit: VolumeFormatterUnit) -> (String, String) {
        let numberString = numberFormatter.stringForObjectValue(value)!

        let unitString: String // values based on HKUnit.unitString
        switch unit {
        case .Milliliter:
            unitString = "mL"
        case .Centiliter:
            unitString = "cL"
        case .Deciliter:
            unitString = "dL"
        case .Liter:
            unitString = "L"
        case .FluidOunceUS:
            unitString = "fl_oz_us"
        case .FluidOunceImperial:
            unitString = "fl_oz_imp"
        case .PintUS:
            unitString = "pt_us"
        case .PintImperial:
            unitString = "pt_imp"
        case .CupUS:
            unitString = "cup_us"
        case .CupImperial:
            unitString = "cup_imp"
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
    
    private func localeAppropriateValueAndUnitFromLiter(numberInLiters: Double) -> (Double, VolumeFormatterUnit) {
        var locale = NSLocale.autoupdatingCurrentLocale()
        // for unit testing
        if let localeIdentifier = NSUserDefaults.standardUserDefaults().volatileDomainForName(NSArgumentDomain)["AppleLocale"] as? String {
            locale = NSLocale(localeIdentifier: localeIdentifier)
        }
        
        if locale.objectForKey(NSLocaleUsesMetricSystem)?.boolValue == false {
            if numberInLiters >= 0.236588 { // >= 1 cup
                // Convert L to US cup
                let numberInCupUS = (numberInLiters * 4.22675)
                return (numberInCupUS, .CupUS)
            }
            else {
                // Convert L to US fl oz
                let numberInFluidOunceUS = (numberInLiters * 33.814)
                return (numberInFluidOunceUS, .FluidOunceUS)
            }
        }

        if numberInLiters >= 1.0 {
            return (numberInLiters, .Liter)
        }
        // Convert L to dL
        let numberInDeciliters = (numberInLiters / 0.1)
        if numberInDeciliters >= 1.0 {
            return (numberInDeciliters, .Deciliter)
        }
        // Convert L to cL
        let numberInCentiliters = (numberInLiters / 0.01)
        if numberInCentiliters >= 1.0 {
            return (numberInCentiliters, .Centiliter)
        }
        // Convert L to mL
        let numberInMilliliters = (numberInLiters / 0.001)
        return (numberInMilliliters, .Milliliter)
    }

}

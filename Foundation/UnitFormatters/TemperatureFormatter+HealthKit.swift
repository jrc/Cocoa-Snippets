//
//  TemperatureFormatter+HealthKit.swift
//  TurkeyTime
//
//  Created by John Chang on 06/09/15.
//  Copyright © 2015 John Chang. All rights reserved.
//

import Foundation
import HealthKit

extension TemperatureFormatter {

    class func HKUnitFromTemperatureFormatterUnit(temperatureFormatterUnit: TemperatureFormatterUnit) -> HKUnit
    {
        switch temperatureFormatterUnit {
        case .Celsius:
            return HKUnit.degreeCelsiusUnit()
        case .Fahrenheit:
            return HKUnit.degreeFahrenheitUnit()
        case .Kelvin:
            return HKUnit.kelvinUnit()
        }
    }

    class func temperatureFormatterUnitFromHKUnit(unit: HKUnit) -> TemperatureFormatterUnit
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

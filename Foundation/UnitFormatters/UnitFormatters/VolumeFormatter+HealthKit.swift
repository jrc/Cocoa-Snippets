//
//  VolumeFormatter+HealthKit.swift
//  TurkeyTime
//
//  Created by John Chang on 07/09/15.
//  Copyright © 2015 John Chang. All rights reserved.
//

import Foundation
import HealthKit

extension VolumeFormatter {
    
    class func HKUnitFromVolumeFormatterUnit(volumeFormatterUnit: VolumeFormatterUnit) -> HKUnit
    {
        switch volumeFormatterUnit {
        case .Milliliter:
            return HKUnit.literUnitWithMetricPrefix(.Milli)
        case .Centiliter:
            return HKUnit.literUnitWithMetricPrefix(.Centi)
        case .Deciliter:
            return HKUnit.literUnitWithMetricPrefix(.Deci)
        case .Liter:
            return HKUnit.literUnit()
        case .FluidOunceUS:
            return HKUnit.fluidOunceUSUnit()
        case .FluidOunceImperial:
            return HKUnit.fluidOunceImperialUnit()
        case .PintUS:
            return HKUnit.pintUSUnit()
        case .PintImperial:
            return HKUnit.pintImperialUnit()
        default:
            if #available(iOS 9.0, *) {
                if (volumeFormatterUnit == .CupUS) {
                    return HKUnit.cupUSUnit()
                } else if (volumeFormatterUnit == .CupImperial) {
                    return HKUnit.cupImperialUnit()
                }
            }
            return HKUnit.literUnit()
        }
    }
    
    class func volumeFormatterUnitFromHKUnit(unit: HKUnit) -> VolumeFormatterUnit
    {
        if unit == HKUnit.literUnitWithMetricPrefix(.Milli) {
            return .Milliliter
        }
        else if unit == HKUnit.literUnitWithMetricPrefix(.Centi) {
            return .Centiliter
        }
        else if unit == HKUnit.literUnitWithMetricPrefix(.Deci) {
            return .Deciliter
        }
        else if unit == HKUnit.literUnit() {
            return .Liter
        }
        else if unit == HKUnit.fluidOunceUSUnit() {
            return .FluidOunceUS
        }
        else if unit == HKUnit.fluidOunceImperialUnit() {
            return .FluidOunceImperial
        }
        else if unit == HKUnit.pintUSUnit() {
            return .PintUS
        }
        else if unit == HKUnit.pintImperialUnit() {
            return .PintImperial
        }
        else if unit == HKUnit.fluidOunceUSUnit() {
            return .FluidOunceUS
        }
        if #available(iOS 9.0, *) {
            if unit == HKUnit.cupUSUnit() {
                return .CupUS
            }
            else if unit == HKUnit.cupImperialUnit() {
                return .CupImperial
            }
        }
        
        NSException.raise(NSInvalidArgumentException, format: "No mapping for unit %@ to VolumeFormatterUnit", arguments: getVaList([unit.unitString]))
        return .Liter
    }
    
}

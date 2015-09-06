//
//  main.swift
//  TemperatureFormatter
//
//  Created by John Chang on 06/09/15.
//  Copyright © 2015 John Chang. All rights reserved.
//

import Foundation

print("Hello, World!")

//let temperatureFormatter = TemperatureFormatter()
//print(temperatureFormatter.stringFromCelsius(100.0))
print("localeIdentifier=" + String(NSLocale.autoupdatingCurrentLocale().localeIdentifier))
print("localeIdentifier=" + String(NSLocale.currentLocale().localeIdentifier))
print("NSLocaleUsesMetricSystem=" + String(NSLocale.autoupdatingCurrentLocale().objectForKey(NSLocaleUsesMetricSystem)!))

print("AppleLocale=" + NSUserDefaults.standardUserDefaults().stringForKey("AppleLocale")!)

NSUserDefaults.standardUserDefaults().setVolatileDomain([
    "AppleLanguages": ["en"],
    "AppleLocale": "en_US",
    "AppleMetricUnits": false
    ], forName:NSArgumentDomain)

print(NSUserDefaults.standardUserDefaults().volatileDomainForName(NSArgumentDomain))

//NSUserDefaults.standardUserDefaults().synchronize()
print("AppleLocale=" + NSUserDefaults.standardUserDefaults().stringForKey("AppleLocale")!)
//print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
////NSUserDefaults.standardUserDefaults().setBool(false, forKey: "AppleMetricUnits")
print("localeIdentifier=" + String(NSLocale.autoupdatingCurrentLocale().localeIdentifier))
print("NSLocaleUsesMetricSystem=" + String(NSLocale.autoupdatingCurrentLocale().objectForKey(NSLocaleUsesMetricSystem)!))
//print(temperatureFormatter.stringFromCelsius(100.0))
//
//NSUserDefaults.standardUserDefaults().removeObjectForKey("AppleMetricUnits")

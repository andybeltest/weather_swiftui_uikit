//
//  Double+Extension.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation

extension Double {
    func kelvinToFahrenheit() -> Double {
        let fahrenheit = (self - 273.15) * 9/5 + 32
        return fahrenheit
    }
    
    func roundedToStringToOneDecimalPlace() -> String {
        let roundedValue = String(format: "%.1f", self)
        return roundedValue
    }
}

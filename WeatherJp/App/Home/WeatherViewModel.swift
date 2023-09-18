//
//  HomeWeatherViewModel.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var city: String?
    @Published var temp: String?
    
    init(city: String? = nil, temp: String? = nil) {
        self.city = city
        self.temp = temp
    }
    
    func setPlaceWeather(_ placeWeather: PlaceWeather) {
        city = placeWeather.name
        temp = "\(placeWeather.main.temp.kelvinToFahrenheit().roundedToStringToOneDecimalPlace()) F"
    }
}

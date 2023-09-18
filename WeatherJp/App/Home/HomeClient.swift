//
//  HomeService.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation
import Swinject
import CoreLocation

protocol HomeService {
    func requestWeather(location: CLLocation) async throws -> PlaceWeather
}

class HomeClient: HomeService {
    var networkService: NetworkService
    
    init(container: Container) {
        networkService = container.get(NetworkService.self)
    }
    
    func requestWeather(location: CLLocation) async throws -> PlaceWeather {
        // https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={API key}
        let (data, _) = try await networkService.requestData(
            relativeUrl: "https://api.openweathermap.org/data/2.5/weather",
            parameters: ["lat": location.coordinate.latitude,
                         "lon" : location.coordinate.longitude])
        do {
            let weather = try JSONDecoder().decode(PlaceWeather.self, from: data)
            return weather
        } catch {
            print(error)
            throw error
        }
    }
}

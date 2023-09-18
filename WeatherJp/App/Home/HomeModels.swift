//
//  HomeModel.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation

struct HomeModel {
    var place: PlaceWeather
}

struct PlaceWeather: Codable {
    var id: Int
    var weather: [Weather]
    var main: Main
    var name: String
    var coord: Coord
}

struct Coord: Codable {
    var lon: Double
    var lat: Double
}

struct Main: Codable {
    var temp: Double
    var pressure: Double
    var humidity: Double
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

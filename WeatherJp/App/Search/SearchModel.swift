//
//  SearchModel.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation

struct Place: Codable {
    var name: String
    var lat: Double
    var lon: Double
    var country: String
    var state: String?
}

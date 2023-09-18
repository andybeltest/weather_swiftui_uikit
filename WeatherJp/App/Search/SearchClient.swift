//
//  SearchClient.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation
import Swinject

protocol SearchService {
    func search(text: String, limit: Int) async throws -> [Place]
}

class SearchClient: SearchService {
    var networkService: NetworkService
    
    init(container: Container) {
        networkService = container.get(NetworkService.self)
    }
    
    func search(text: String, limit: Int) async throws -> [Place] {
        // https://api.openweathermap.org/geo/1.0/direct?q=London&limit=5&appid={API key}
        let (data, _) = try await networkService.requestData(
            relativeUrl: "https://api.openweathermap.org/geo/1.0/direct",
            parameters: ["q": text,
                         "limit" : limit])
        do {
            let places = try JSONDecoder().decode([Place].self, from: data)
            return places
        } catch {
            print(error)
            throw error
        }
    }
}

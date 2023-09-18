//
//  SearchViewModel.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation
import Swinject

class SearchViewModel {
    let container: Container
    let searchService: SearchService
    var prevResult = [SearchItem]()
    
    init(container: Container) {
        self.container = container
        self.searchService = container.get(SearchService.self)
    }
    
    @MainActor
    func search(text: String) async throws -> [SearchItem] {
        let places = try await searchService.search(text: text, limit: 10)
        prevResult = places
            .compactMap { place in
                guard let state = place.state else { return nil }
                return SearchItem(name: place.name,
                                  lat: place.lat,
                                  lon: place.lon,
                                  state: state,
                                  country: place.country)
            }.uniqued()
        return prevResult
    }
}

struct SearchItem: Identifiable, Hashable {
    var id: String {
        name + ", " + state + ", " + country
    }
    
    var name: String
    var lat: Double
    var lon: Double
    var state: String
    var country: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SearchSection: Hashable {
    let id: String
}

public extension Sequence where Element: Hashable {
    
    /// Return the sequence with all duplicates removed.
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
}

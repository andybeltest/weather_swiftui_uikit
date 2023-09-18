//
//  HomeViewModel.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation
import AsyncLocationKit
import CoreLocation
import Swinject

@MainActor
class HomeViewModel: ObservableObject {
    var weather = WeatherViewModel()
    @Published var placeWeather: PlaceWeather?
    @Published var isRequestingLocation = false
    @Published var isFetching = false
    @Published var deviceLocation: LocationUpdateEvent? {
        didSet {
            print(deviceLocation as Any)
        }
    }
    let container: Container
    let homeService: HomeService
    let storageService: StorageService

    init(container: Container) {
        self.container = container
        self.homeService = container.get(HomeService.self)
        self.storageService = container.get(StorageService.self)
        // it might sense to move that on appear
        if let placeWeather = storageService.retrieve(PlaceWeather.self, forKey: "currentPlaceWeather") {
            weather.setPlaceWeather(placeWeather)
            Task {
                await fetchWeather(location: CLLocation(latitude: placeWeather.coord.lat,
                                                        longitude: placeWeather.coord.lon))
            }
        }
    }
    
    func requestLocation() {
        guard !isRequestingLocation else { return }
        // it should be abstract into injectable service
        let asyncLocationManager = AsyncLocationManager(desiredAccuracy: .bestAccuracy)
        isRequestingLocation = true
        Task {
            let permission = await asyncLocationManager.requestPermission(with: .whenInUsage)
            if permission == .authorizedWhenInUse {
                let event = try? await asyncLocationManager.requestLocation()
                deviceLocation = event
            }
            if case .didUpdateLocations(let locations) = deviceLocation, let location = locations.first {
                await fetchWeather(location: location)
                self.isFetching = false
            }
            self.isRequestingLocation = false
        }
    }
    
    func startFetchWeather(location: CLLocation)  {
        Task {
            await fetchWeather(location: location)
        }
    }
    
    func fetchWeather(location: CLLocation) async {
        self.isFetching = true
        if let placeWeather = try? await homeService.requestWeather(location: location) {
            weather.setPlaceWeather(placeWeather)
            storageService.store(placeWeather, forKey: "currentPlaceWeather")
        }
        self.isFetching = false
    }
}

extension HomeViewModel: SearchViewControllerDelegate {
    func didSelect(controller: SearchViewController, item: SearchItem) {
        startFetchWeather(location: CLLocation(latitude: item.lat, longitude: item.lon))
    }
}

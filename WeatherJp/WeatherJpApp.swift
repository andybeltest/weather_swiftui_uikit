//
//  WeatherJpApp.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import SwiftUI
import Swinject

// defines services used in the production app
private let appContainer = Container() { container in
    container.register(NetworkService.self) { _ in AppNetworkService() }
    container.register(HomeService.self) { _ in HomeClient(container: container) }
    container.register(SearchService.self) { _ in SearchClient(container: container) }
    container.register(StorageService.self) { _ in UserDefaultsStorage() }

}

#if DEBUG
// open as debug container to use in previews
public let debugContainer = appContainer
#endif

@main
struct WeatherJpApp: App {
    // MARK: - App
    var body: some Scene {
        WindowGroup {
            ContentView(container: appContainer)
        }
    }
}

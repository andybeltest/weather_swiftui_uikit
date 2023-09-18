//
//  Container+Extension.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation
import Swinject

extension Container {
    public func get<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = resolve(serviceType, name: nil) else {
            fatalError("Couldn't resolve \(serviceType)")
        }
        return service
    }
}

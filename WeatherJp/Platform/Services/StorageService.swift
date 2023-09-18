//
//  StorageService.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation

protocol StorageService {
    func store<T: Codable>(_ object: T, forKey key: String)
    func retrieve<T: Codable>(_ type: T.Type, forKey key: String) -> T?
}

class UserDefaultsStorage: StorageService {
    private let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    func store<T: Codable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(object) {
            userDefaults.set(encodedData, forKey: key)
        }
    }
    
    func retrieve<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = userDefaults.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decodedObject = try? decoder.decode(type, from: data) {
                return decodedObject
            }
        }
        return nil
    }
    
    func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

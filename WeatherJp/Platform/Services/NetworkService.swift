//
//  NetworkService.swift
//  WeatherJp
//
//  Created by Andrey Belonogov on 9/17/23.
//

import Foundation
import Combine

enum NetworkError {
    case badData
}

protocol NetworkService {
    func requestData(relativeUrl: String, parameters: [String: Encodable]) async throws -> (Data, URLResponse)
}

class AppNetworkService: NetworkService {
    let urlSession = URLSession.shared
    let apiKey = "45a05e567121702b8c0acd569d07e9ca" //940b681f8a929e466177c8514cbb4008
   
    func requestData(relativeUrl: String, parameters: [String: Encodable]) async throws -> (Data, URLResponse) {
        var parameters = parameters
        parameters["appid"] = apiKey
        let url = URL(string: urlString(relativeUrl: relativeUrl, parameters: parameters))!
        let result = try await urlSession.data(from: url)
        #if DEBUG
        print(url)
        print(String(data: result.0, encoding: .utf8)! as NSString)
        #endif
        return result
    }
    
    func urlString(relativeUrl: String, parameters: [String: Encodable]) -> String {
        let query = parameters.queryString()
        return "\(relativeUrl)?\(query)"
    }
}

extension Dictionary where Key == String, Value == Encodable {
    func queryString() -> String {
        var components = URLComponents()
        components.queryItems = self.map { key, value in
            URLQueryItem(name: key, value: String(describing: value)
                .replacingOccurrences(of: " ", with: "-")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                )
        }
        return components.percentEncodedQuery ?? ""
    }
}

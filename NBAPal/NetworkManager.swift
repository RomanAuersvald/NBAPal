//
//  NetworkManager.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import UIKit
import Combine

enum RequestError: Error {
    case badRequest
}

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    let apiSecret = "741c5815-4fec-475a-9c62-ad0a73b7907a"
    
    private var cursor = 0
    private var isPlayersComplete = false
    
    func getPlayers(perPage: Int, cursor: Int) -> AnyPublisher<Wrap, Error> {
        var urlComponents = URLComponents(string: "https://api.balldontlie.io/v1/players")!
        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "cursor", value: "\(cursor)")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.setValue(NetworkManager.shared.apiSecret, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {$0.data}
            .decode(type: Wrap.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    

}

struct Wrap: Codable{
    let data: [Player]?
    let meta: Meta?
}

struct Meta: Codable{
    let nextCursor, perPage: Int?
}

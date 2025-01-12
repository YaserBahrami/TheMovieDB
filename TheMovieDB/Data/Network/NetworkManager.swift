//
//  NetworkManager.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Foundation
import Combine


class NetworkManager: NetworkManagerProtocol {
    func fetch<T: Decodable>(_ type: T.Type, _ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: type, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

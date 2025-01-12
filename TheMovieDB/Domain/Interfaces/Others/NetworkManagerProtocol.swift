//
//  NetworkManagerProtocol.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Combine

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(_ type: T.Type, _ endpoint: Endpoint) -> AnyPublisher<T, Error>
}


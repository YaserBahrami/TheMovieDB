//
//  AppConfig.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Foundation

struct AppConfig {
    static let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String else {
            fatalError("API Key is missing in Config.plist")
        }
        return key
    }()
    
    static let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("Base URL is missing in Config.plist")
        }
        return url
    }()
}

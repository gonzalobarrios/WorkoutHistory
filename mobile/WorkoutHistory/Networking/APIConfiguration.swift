//
//  APIConfiguration.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation

enum APIEnvironment {
    case production
    case debug
    
    var baseURL: URL {
        switch self {
        case .production:
            return URL(string: "https://example.com/json")!
        case .debug:
            return URL(string: "https://example.com/json")!
        }
    }
}

struct APIConfiguration {
    #if DEBUG
    static let environment: APIEnvironment = .debug
    #else
    static let environment: APIEnvironment = .production
    #endif
    
    static var baseURL: URL {
        return environment.baseURL
    }
    
}

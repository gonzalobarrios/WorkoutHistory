//
//  NetworkError.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case requestFailed(Error)
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse(let statusCode):
            return "Invalid Response from the server. Status code: \(statusCode)"
        case .noData:
            return "No data returned from the server"
        case .requestFailed(let error):
            return "Request Failed: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding Error: \(error.localizedDescription)"
        }
    }
}

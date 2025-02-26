//
//  NetworkManager.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

protocol NetworkManagerProtocol {
    func performRequest<T: Codable>(url: URL, method: HTTPMethod, body: Data?) async throws -> T
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager(session: .shared)
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func performRequest<T: Codable>(url: URL, method: HTTPMethod, body: Data? = nil) async throws -> T {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse(statusCode: -1)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch let requestError as NetworkError {
            throw requestError
        } catch {
            throw error
        }
    }
}

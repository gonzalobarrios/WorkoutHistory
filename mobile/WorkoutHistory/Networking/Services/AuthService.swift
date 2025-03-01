//
//  AuthService.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/28/25.
//

import Foundation

protocol AuthServiceProtocol {
    func signup(name: String, email: String, password: String) async throws -> String
    func login(email: String, password: String) async throws -> String
}

final class AuthService: AuthServiceProtocol {
    private let baseURL = "http://localhost:5001"
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func signup(name: String, email: String, password: String) async throws -> String {
        let url = URL(string: "\(baseURL)/auth/signup")!
        let body = ["name": name, "email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: body)

        let response: AuthResponse = try await networkManager.performRequest(url: url, method: .POST, body: jsonData, headers: nil)
        return response.message
    }

    func login(email: String, password: String) async throws -> String {
        let url = URL(string: "\(baseURL)/auth/login")!
        let body = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: body)

        let response: LoginResponse = try await networkManager.performRequest(url: url, method: .POST, body: jsonData, headers: nil)
        TokenManager.shared.saveToken(response.token)
        return response.token
    }
}

struct AuthResponse: Codable {
    let message: String
}

struct LoginResponse: Codable {
    let token: String
}

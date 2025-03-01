//
//  TokenManager.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/28/25.
//

import Foundation

final class TokenManager {
    static let shared = TokenManager()
    private let tokenKey = "jwtToken"

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func getToken() -> String? {
        let token = UserDefaults.standard.string(forKey: tokenKey)
        return token?.isEmpty == true ? nil : token
    }

    func authHeader() -> [String: String] {
        guard let token = getToken() else { return [:] }
        return ["Authorization": "Bearer \(token)"]
    }

    func removeToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}

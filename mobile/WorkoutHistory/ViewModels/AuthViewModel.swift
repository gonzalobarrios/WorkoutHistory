//
//  AuthViewModel.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/28/25.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        let token = TokenManager.shared.getToken()
        self.isAuthenticated = token?.isEmpty == false
    }

    func login(email: String, password: String, onSuccess: @escaping () -> Void) async {
        do {
            let token = try await authService.login(email: email, password: password)
            TokenManager.shared.saveToken(token)
            isAuthenticated = true
            onSuccess()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signup(name: String, email: String, password: String) async {
        do {
            let message = try await authService.signup(name: name, email: email, password: password)
            print("Signup Successful: \(message)")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func logout() {
        TokenManager.shared.saveToken("")
        isAuthenticated = false
    }
}

//
//  SignupView.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 3/1/25.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSuccess = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal)
                }

                CustomTextField(placeholder: "Name", text: $name)
                CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)

                Button("Sign Up") {
                    Task {
                        await signUpUser()
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 10)

                if isSuccess {
                    Text("Signup Successful! Please log in.")
                        .foregroundColor(.green)
                        .padding(.top, 5)
                }

                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }

    private func signUpUser() async {
        do {
            let message = try await authVM.signup(name: name, email: email, password: password)
            isSuccess = true
            errorMessage = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        }
    }
}

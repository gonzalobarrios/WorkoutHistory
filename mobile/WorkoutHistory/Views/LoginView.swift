//
//  LoginView.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/28/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)

                Button("Login") {
                    Task {
                        await authVM.login(email: email, password: password) {
                            dismiss()
                        }
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 10)

                Button("Sign Up") {
                    showSignup = true
                }
                .foregroundColor(.blue)
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .fullScreenCover(isPresented: $showSignup) {
                SignupView()
                    .environmentObject(authVM)
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            if isSecure {
                SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.6)))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.6)))
                    .keyboardType(keyboardType)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}

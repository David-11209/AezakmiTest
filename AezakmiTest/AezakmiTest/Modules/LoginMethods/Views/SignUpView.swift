//
//  SignUpView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 30.07.2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct SignUpView: View {
    @State private var loginText: String = ""
    @State private var passwordText: String = ""
    @State private var loginError: String? = nil
    @State private var passwordError: String? = nil
    @State private var isPasswordRecovery: Bool = false
    @State private var isUserSignUp: Bool = false
    @State private var isLoading: Bool = false
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        VStack {
                Text("Регистрация")
                .font(.system(size: 24))
                .padding()
                .multilineTextAlignment(.center)

                RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                    .overlay {
                        TextField("Login", text: $loginText)
                            .padding()
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .onChange(of: loginText) { newValue in
                                loginError = nil
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom, 5)
                }

                RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                    .overlay {
                        SecureField("Password", text: $passwordText)
                            .padding()
                            .onChange(of: passwordText) { newValue in
                                passwordError = nil
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)

                if let error = passwordError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom, 5)
                }

                Button(action: {
                    if validateInputs() {
                        isLoading = true
                        viewModel.isEmailUnique(email: loginText) { isUniqueEmail in
                            if isUniqueEmail {
                                viewModel.signUpWithEmail(email: loginText, password: passwordText) { res, er in
                                    isLoading = false
                                    print(res)
                                    print(er)
                                    print()
                                    isUserSignUp = true
                                }
                            }
                        }
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .overlay {
                            Text("Зарегистрироваться")
                                .foregroundStyle(Color.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 60)
                })
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .padding()

        NavigationLink(destination: TestView(), isActive: $isUserSignUp) {
            EmptyView()
        }

//        NavigationLink(destination: EmailVerificationView().environmentObject(viewModel), isActive: $isEmailVerificationPresent) {
//            EmptyView()
//        }
    }


    private func validateInputs() -> Bool {
        // Reset errors
        loginError = nil
        passwordError = nil

        // Validate email
        if !isValidEmail(loginText) {
            loginError = "Введите корректный адрес электронной почты."
            return false
        }

        // Validate password length
        if passwordText.count < 8 {
            passwordError = "Пароль должен содержать не менее 8 символов."
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        // Simple regex for email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    SignUpView()
        .environmentObject(ViewModel())
}

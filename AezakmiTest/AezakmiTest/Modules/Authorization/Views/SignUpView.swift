//
//  SignUpView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 30.07.2024.
//

import SwiftUI

struct SignUpView: View {
    @State private var loginText: String = ""
    @State private var passwordText: String = ""
    @State private var loginError: String? = nil
    @State private var passwordError: String? = nil
    @State private var isPasswordRecovery: Bool = false
    @State private var isUserSignUp: Bool = false
    @State private var isLoading: Bool = false
    @State private var isAlertPresented: Bool = false
    @EnvironmentObject var viewModel: AuthorizationViewModel

    var body: some View {
        VStack(alignment: .center) {
                Text("Регистрация")
                .font(.system(size: 24))
                .multilineTextAlignment(.center)

            TextField("Login", text: $loginText)
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .onChange(of: loginText) { newValue in
                    loginError = nil
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 1)
                }

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom, 5)
                }

            SecureField("Password", text: $passwordText)
                .padding()
                .onChange(of: passwordText) { newValue in
                    passwordError = nil
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 1)
                }

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
                                    isUserSignUp = true
                                }
                            } else {
                                isAlertPresented = true
                                isLoading = false
                            }
                        }
                    }
                }, label: {
                    Text("Зарегистрироваться")
                        .buttonLabelModifier()
                })
            NavigationLink(destination: MainView().environmentObject(viewModel), isActive: $isUserSignUp) {
                EmptyView()
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Ошибка регистрации"), message: Text("Пользователь с таким email уже существует"), dismissButton: .default(Text("ОК")))
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .padding()
    }

    private func validateInputs() -> Bool {

        loginError = nil
        passwordError = nil

        if !isValidEmail(loginText) {
            loginError = "Введите корректный адрес электронной почты."
            return false
        }

        if passwordText.count < 8 {
            passwordError = "Пароль должен содержать не менее 8 символов."
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthorizationViewModel())
}

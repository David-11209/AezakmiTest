//
//  LoginMethodsView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 29.07.2024.
//

import SwiftUI

struct LoginMethodsView: View {
    @State var isSignInPresented: Bool = false
    @State var isSignUpPresented: Bool = false
    @State var isContentPresented: Bool = false
    @StateObject var viewModel: AuthorizationViewModel = AuthorizationViewModel()
    var body: some View {
        VStack {

            Button(action: {
                isSignInPresented = true
            }, label: {
                Text("Авторизация")
                    .buttonLabelModifier()
            })

            Button(action: {
                isSignUpPresented = true
            }, label: {
                Text("Регистрация")
                    .buttonLabelModifier()
            })

            Button(action: {
                Task {
                    let result = await viewModel.signInWithGoogle()
                    if result {
                        isContentPresented = true
                    }
                }
            }, label: {
                Text("Войти через Google")
                    .buttonLabelModifier()
                    .overlay(alignment: .leading) {
                        Image(.googleIcon)
                            .resizable()
                            .frame(maxWidth: 40, maxHeight: 40)
                            .padding(.horizontal)
                    }
            })

            NavigationLink(destination: SignInView().environmentObject(viewModel), isActive: $isSignInPresented) {
                EmptyView()
            }

            NavigationLink(destination: SignUpView().environmentObject(viewModel), isActive: $isSignUpPresented) {
                EmptyView()
            }

            NavigationLink(destination: MainView().environmentObject(viewModel), isActive: $isContentPresented) {
                EmptyView()
            }
        }
        .padding(.horizontal)
    }

    //    @State private var loginText: String = ""
    //    @State private var passwordText: String = ""
    //    @State private var loginError: String? = nil
    //    @State private var passwordError: String? = nil
    //    @State private var isPasswordRecovery: Bool = false
    //    @State private var user: GIDGoogleUser? = nil
    //    var viewModel: ViewModel = ViewModel()
    //
    //    var body: some View {
    //        VStack {
    //                // Login form
    //                RoundedRectangle(cornerRadius: 16)
    //                    .fill(Color.blue.opacity(0.2))
    //                    .overlay {
    //                        TextField("Login", text: $loginText)
    //                            .foregroundStyle(Color.white)
    //                            .padding()
    //                            .keyboardType(.emailAddress)
    //                            .autocapitalization(.none)
    //                            .onChange(of: loginText) { newValue in
    //                                loginError = nil
    //                            }
    //                    }
    //                    .frame(maxWidth: .infinity, maxHeight: 60)
    //
    //                if let error = loginError {
    //                    Text(error)
    //                        .foregroundColor(.red)
    //                        .font(.caption)
    //                        .padding(.bottom, 5)
    //                }
    //
    //                RoundedRectangle(cornerRadius: 16)
    //                    .fill(Color.blue.opacity(0.2))
    //                    .overlay {
    //                        SecureField("Password", text: $passwordText)
    //                            .foregroundStyle(Color.white)
    //                            .padding()
    //                            .onChange(of: passwordText) { newValue in
    //                                passwordError = nil
    //                            }
    //                    }
    //                    .frame(maxWidth: .infinity, maxHeight: 60)
    //
    //                if let error = passwordError {
    //                    Text(error)
    //                        .foregroundColor(.red)
    //                        .font(.caption)
    //                        .padding(.bottom, 5)
    //                }
    //
    //                Button(action: {
    //                    validateInputs()
    //                    viewModel.signInWithEmail(email: loginText, password: passwordText) { res, er in
    //                        print(res)
    //                        print(er)
    //                    }
    //                }, label: {
    //                    RoundedRectangle(cornerRadius: 16)
    //                        .fill(Color.blue.opacity(0.6))
    //                        .overlay {
    //                            Text("Войти")
    //                                .foregroundStyle(Color.white)
    //                                .padding()
    //                        }
    //                        .frame(maxWidth: .infinity, maxHeight: 60)
    //                })
    //
    //                Button(action: {
    //                    validateInputs()
    //                    viewModel.signUpWithEmail(email: loginText, password: passwordText) { res, er in
    //                        print(res)
    //                        print(er)
    //                    }
    //                }, label: {
    //                    RoundedRectangle(cornerRadius: 16)
    //                        .fill(Color.blue.opacity(0.6))
    //                        .overlay {
    //                            Text("Зарегистрироваться")
    //                                .foregroundStyle(Color.white)
    //                                .padding()
    //                        }
    //                        .frame(maxWidth: .infinity, maxHeight: 60)
    //                })
    //
    //
    //                    Button(action: {
    //                        validateInputs()
    //                        Task {
    //                            let result = await viewModel.signInWithGoogle()
    //                        }
    //                    }, label: {
    //                        RoundedRectangle(cornerRadius: 16)
    //                            .fill(Color.blue.opacity(0.6))
    //                            .overlay {
    //                                Text("Войти через Google")
    //                                    .foregroundStyle(Color.white)
    //                                    .padding()
    //                            }
    //                            .frame(maxWidth: .infinity, maxHeight: 60)
    //                    })
    //
    //
    //                Button(action: {
    //                    isPasswordRecovery = true
    //                    viewModel.resetPassword(email: loginText)
    //                }, label: {
    //                    Text("Восстановить пароль")
    //                })
    //        }
    //        .sheet(isPresented: $isPasswordRecovery, content: {
    //            Text("Восстановление пароля")
    //        })
    //        .padding()
    //    }
    //
    //    private func validateInputs() {
    //        // Reset errors
    //        loginError = nil
    //        passwordError = nil
    //
    //        // Validate email
    //        if !isValidEmail(loginText) {
    //            loginError = "Введите корректный адрес электронной почты."
    //        }
    //
    //        // Validate password length
    //        if passwordText.count < 8 {
    //            passwordError = "Пароль должен содержать не менее 8 символов."
    //        }
    //
    //        // You can proceed with login if there are no errors
    //        if loginError == nil && passwordError == nil {
    //            // Perform login action
    //            print("Login successful!")
    //        }
    //    }
    //
    //    private func isValidEmail(_ email: String) -> Bool {
    //        // Simple regex for email validation
    //        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
    //        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    //        return emailTest.evaluate(with: email)
    //    }
}

#Preview {
    LoginMethodsView()
}


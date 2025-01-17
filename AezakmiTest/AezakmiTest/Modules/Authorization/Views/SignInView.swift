//
//  SignInView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 30.07.2024.
//

import SwiftUI

struct SignInView: View {
    @State private var loginText: String = ""
    @State private var passwordText: String = ""
    @State private var loginError: String? = nil
    @State private var passwordError: String? = nil
    @State private var isPasswordRecovery: Bool = false
    @State private var isUserLogin: Bool = false
    @State private var isAlertPresented: Bool = false
    @State private var isLoading: Bool = false
    @EnvironmentObject var viewModel: AuthorizationViewModel
    
    var body: some View {
        VStack {
            Text("Авторизация")
                .font(.system(size: 24))
                .padding()
                .multilineTextAlignment(.center)
            
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .overlay {
                    TextField("Email", text: $loginText)
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
                    viewModel.signInWithEmail(email: loginText, password: passwordText) { res, er in
                        isLoading = false
                        if res {
                            isUserLogin = true
                        } else {
                            isAlertPresented = true
                        }
                    }
                }
            }, label: {
                Text("Войти")
                    .buttonLabelModifier()
            })
            
            
            Button(action: {
                isPasswordRecovery = true
            }, label: {
                Text("Восстановить пароль")
                    .foregroundStyle(Color.black.opacity(0.5))
            })


        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Ошибка авторизации"), message: Text("Такого пользователя не существует"), dismissButton: .default(Text("ОК")))
        }
        .sheet(isPresented: $isPasswordRecovery, content: {
            VStack {

                Text("Укажите Email на который мы вышлем письмо с ссылкой для восстановления пароля")
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

                
                Button(action: {
                    viewModel.resetPassword(email: loginText)
                    loginText = ""
                    isPasswordRecovery = false
                }, label: {
                    Text("Продолжить")
                        .buttonLabelModifier()
                })
            }
            .padding()
        })
        .padding()
        
        NavigationLink(destination: MainView().environmentObject(viewModel), isActive: $isUserLogin) {
            EmptyView()
        }
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
    SignInView()
        .environmentObject(AuthorizationViewModel())
}

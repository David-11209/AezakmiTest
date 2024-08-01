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
}

#Preview {
    LoginMethodsView()
}


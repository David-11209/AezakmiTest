//
//  EmailVerificationView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 30.07.2024.
//

import SwiftUI

struct EmailVerificationView: View {

    @EnvironmentObject var viewModel: ViewModel
    @State var isEmailVerified: Bool = false
    @State var isAlertPresented: Bool = false
    var body: some View {
        VStack {
            Text("Письмо с подтверждением email было выслано вам на почту")
                .font(.system(size: 24))
                .padding()
                .multilineTextAlignment(.center)

            Button(action: {
                viewModel.checkEmailVerification { _isEmailVerified in
                    if _isEmailVerified {
                        isEmailVerified = _isEmailVerified
                    } else  {
                        isAlertPresented = true
                    }
                }
            }, label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
                    .overlay {
                        Text("Продолжить")
                            .foregroundStyle(Color.white)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
            })
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Ваш email не подтвержден"), message: Text(""), dismissButton: .default(Text("ОК")))
        }
        
        NavigationLink(destination: TestView(), isActive: $isEmailVerified) {
            EmptyView()
        }
    }
}

#Preview {
    EmailVerificationView()
}

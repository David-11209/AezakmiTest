//
//  EmailVerificationView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 30.07.2024.
//

import SwiftUI

struct EmailVerificationView: View {

    @EnvironmentObject var viewModel: AuthorizationViewModel
    @State var isEmailVerified: Bool = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("Письмо с подтверждением email было выслано вам на почту")
                .font(.system(size: 24))
                .padding()
                .multilineTextAlignment(.center)

            Button(action: {
                viewModel.sendEmailVerification { res, err in
                    print("отправка письма с верификацией, результат: \(res)")
                }
                dismiss()
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
        .padding()
    }
}

#Preview {
    EmailVerificationView()
}

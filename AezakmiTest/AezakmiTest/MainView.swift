//
//  MainView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//


import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthorizationViewModel
    @State private var isShowingImagePicker = false
    @State private var image: UIImage?
    @State private var shouldNavigate = false
    @State private var isCameraSheetPresented = false
    @State private var isEmailVerificationPresented = false
    @State private var isUserNotVerified = false
    @State private var isAlertPresented = false

    var body: some View {
        VStack {
            Button(action: {
                self.isShowingImagePicker = true
            }) {
                Text("Выбрать фото из галереи")
                    .buttonLabelModifier()
            }

            Button(action: {
                self.isCameraSheetPresented = true
            }) {
                Text("Сделать фото")
                    .buttonLabelModifier()
            }

            if isUserNotVerified {
                Button(action: {
                    isEmailVerificationPresented = true
                }) {
                    Text("Подтвердить почту")
                }
            }

            NavigationLink(destination: EditingMenuView(image: image ?? UIImage()), isActive: $shouldNavigate) {
                EmptyView()
            }
        }
        .onAppear {
            viewModel.checkEmailVerification { result in
                isUserNotVerified = !result
                isAlertPresented = !result
            }
        }
        .padding()
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Ваш email не подтвержден"), message: Text(""), dismissButton: .default(Text("ОК")))
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: { shouldNavigate = true }) {
            ImagePickerView(isShown: $isShowingImagePicker, sourceType: .photoLibrary, selectedImage: $image)
        }
        .sheet(isPresented: $isCameraSheetPresented, onDismiss: loadImage) {
            ImagePickerView(isShown: $isCameraSheetPresented, sourceType: .camera, selectedImage: $image)
        }
        .sheet(isPresented: $isEmailVerificationPresented, onDismiss: loadImage) {
           EmailVerificationView()
                .environmentObject(viewModel)
        }
    }

    private func loadImage() {
        if image != nil {
            shouldNavigate = true
        }
    }
}

#Preview {
    MainView()
}

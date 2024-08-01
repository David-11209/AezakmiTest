//
//  EditingModesView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//

import SwiftUI

struct EditingMenuView: View {
    @StateObject var viewModel: ImageEditingViewModel = ImageEditingViewModel()
    @State var isPhotoDrawingPresented: Bool = false
    @State var isTextEditingPresented: Bool = false
    @State var isImageFiltersPresented: Bool = false
    var image: UIImage?

    var body: some View {
        VStack {
            Button(action: {
                isPhotoDrawingPresented = true
            }, label: {
                Text("Рисование")
                    .buttonLabelModifier()
            })

            Button(action: {
                isTextEditingPresented = true
            }, label: {
                Text("Добавление текста")
                    .buttonLabelModifier()
            })

            Button(action: {
                isImageFiltersPresented = true
            }, label: {
                Text("Фильтры")
                    .buttonLabelModifier()
            })

            NavigationLink(destination: PhotoDrawingView(image: image ?? UIImage()).environmentObject(viewModel), isActive: $isPhotoDrawingPresented) {
                EmptyView()
            }
            NavigationLink(destination: TextEditingView(image: image ?? UIImage()).environmentObject(viewModel), isActive: $isTextEditingPresented) {
                EmptyView()
            }
            NavigationLink(destination: ImageFilterView(image: image ?? UIImage()), isActive: $isImageFiltersPresented) {
                EmptyView()
            }
        }
        .padding()
    }
}

#Preview {
    EditingMenuView()
}

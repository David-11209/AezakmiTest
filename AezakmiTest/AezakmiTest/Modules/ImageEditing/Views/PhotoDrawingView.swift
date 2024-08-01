//
//  PhotoDrawingView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//


import SwiftUI
import PencilKit

struct PhotoDrawingView: View {
    @EnvironmentObject var viewModel: ImageEditingViewModel
    @State var isFilterPresented: Bool = false
    var image: UIImage

    var body: some View {
        VStack {
            DrawingView(image: image)
                .environmentObject(viewModel)

            NavigationLink(destination: ImageFilterView(image: image), isActive: $isFilterPresented) {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(isPresented:  $viewModel.showAlert) {
            Alert(title: Text("Message"), message: Text(viewModel.message), dismissButton: .default(Text("OK")))
        }
    }
}

//#Preview {
//    PhotoDrawingView(image: .add)
//}

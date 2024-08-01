//
//  TextEditingView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//

import SwiftUI

struct TextEditingView: View {
    @EnvironmentObject var viewModel: ImageEditingViewModel
    @State var isShareTapped: Bool = false
    var image: UIImage

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.frame(in: .global)

            ZStack {
                CanvasView(image: image, rect: size.size, isToolPickerPresented: false)

                ForEach(viewModel.textBoxes) { box in
                    TextBoxComponent(box: box)
                }

                VStack {
                    Spacer()
                    if viewModel.isEditing {
                        RoundedRectangle(cornerRadius: 16)
                            .overlay {
                                TextEditingFooter()
                                    .environmentObject(viewModel)
                            }
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, maxHeight: 260)
                    }
                }
                .frame(alignment: .bottom)
            }
            .alert(isPresented:  $viewModel.showAlert) {
                Alert(title: Text("Message"), message: Text(viewModel.message), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $isShareTapped, content: {
                ShareSheet(items: [viewModel.shareImage])
            })
            .toolbar {
                ToolbarComponent(isShareTapped: $isShareTapped, isTextEditorPresented: true)
                    .environmentObject(viewModel)
            }
            .onAppear {
                if viewModel.rect == .zero {
                    viewModel.rect = size
                }
            }
            .onDisappear {
                viewModel.textBoxes = []
            }
        }
    }
}

#Preview {
    NavigationView {
        TextEditingView(image: .add)
            .environmentObject(ImageEditingViewModel())
    }
}

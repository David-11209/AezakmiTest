//
//  DrawingCanvas.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//

import SwiftUI

struct DrawingView: View {
    @EnvironmentObject var viewModel: ImageEditingViewModel
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .degrees(0)
    @State private var offset: CGSize = .zero
    @State var isShareTapped: Bool = false
    var image: UIImage

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.frame(in: .global)

            ZStack {
                CanvasView(image: image, rect: size.size, isToolPickerPresented: true)
                    .scaleEffect(scale)
                    .rotationEffect(rotation)
                    .offset(offset)
            }
            .sheet(isPresented: $isShareTapped, content: {
                ShareSheet(items: [viewModel.shareImage])
            })
            .alert(isPresented:  $viewModel.showAlert) {
                Alert(title: Text("Message"), message: Text(viewModel.message), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarComponent(isShareTapped: $isShareTapped)
                    .environmentObject(viewModel)
            }
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = value
                        },
                    RotationGesture()
                        .onChanged { angle in
                            rotation = angle
                        }
                )
            )
            .onAppear {
                if viewModel.rect == .zero {
                    viewModel.rect = size
                }
            }
            .onDisappear {
                viewModel.cancelImageEditing()
            }
        }
    }
}

#Preview {
    DrawingView(image: .add)
        .environmentObject(ImageEditingViewModel())
}

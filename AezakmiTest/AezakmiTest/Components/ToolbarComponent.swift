//
//  ToolbarComponent.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//

import SwiftUI

struct ToolbarComponent: View {
    @EnvironmentObject var viewModel: ImageEditingViewModel
    @Binding var isShareTapped: Bool
    var isTextEditorPresented: Bool = false

    var body: some View {
        if isTextEditorPresented {
            Button(action: {
                if viewModel.isEditing {
                    viewModel.canvasView.becomeFirstResponder()
                    withAnimation {
                        viewModel.isEditing = false
                    }
                } else {
                    viewModel.textBoxes.append(TextBox())
                    viewModel.currentTextIndex = viewModel.textBoxes.count - 1
                    withAnimation {
                        viewModel.isEditing.toggle()
                    }
                    viewModel.canvasView.resignFirstResponder()
                }
            }, label: {
                Text("+")
                    .font(.system(size: 28).bold())
                    .foregroundStyle(Color.black)
            })
        }

        Button(action: {
            viewModel.exportImage(isShared: false)
        }, label: {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.black)
                .frame(width: 26, height: 26)
        })

        Button(action: {
            viewModel.exportImage(isShared: true)
            isShareTapped = true
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.black)
                .frame(width: 26, height: 26)
        })
    }
}

#Preview {
    ToolbarComponent(isShareTapped: .constant(false))
        .environmentObject(ImageEditingViewModel())
}

#Preview {
    ToolbarComponent(isShareTapped: .constant(false), isTextEditorPresented: true)
        .environmentObject(ImageEditingViewModel())
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

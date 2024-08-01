//
//  TextBoxComponent.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//

import SwiftUI

struct TextBoxComponent: View {
    @EnvironmentObject var viewModel: ImageEditingViewModel
    var box: TextBox

    var body: some View {
        if !viewModel.textBoxes.isEmpty {
            Text(viewModel.textBoxes[viewModel.currentTextIndex].id == box.id && viewModel.isEditing ? "" : box.text)
                .fontWeight(box.isBold ? .bold : .regular)
                .foregroundStyle(box.textColor)
                .offset(box.offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let current = value.translation
                            let lastOffset = box.lastOffset
                            let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                            viewModel.textBoxes[viewModel.currentTextIndex].offset = newTranslation
                        }
                        .onEnded { value in
                            viewModel.textBoxes[viewModel.currentTextIndex].lastOffset = value.translation
                        }
                )
                .onLongPressGesture {
                    viewModel.currentTextIndex = getIndex(textBox: box)
                    viewModel.canvasView.resignFirstResponder()
                    withAnimation {
                        viewModel.isEditing = true
                    }
                }
        }
    }

    private func getIndex(textBox: TextBox) -> Int {
        return viewModel.textBoxes.firstIndex { $0.id == textBox.id } ?? 0
    }
}

#Preview {
    let box = TextBox(id: "1", text: "Test text", isBold: false, offset: CGSize(width: 0, height: 0), lastOffset: CGSize(width: 0, height: 0), textColor: Color.green, isAdded: false)
    let viewModel = ImageEditingViewModel()
    viewModel.textBoxes.append(box)
    return TextBoxComponent(box: box)
        .environmentObject(viewModel)
}


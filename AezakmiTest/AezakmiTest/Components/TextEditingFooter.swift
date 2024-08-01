//
//  TextEditingFooter.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//

import SwiftUI

struct TextEditingFooter: View {
    @EnvironmentObject var viewModel: ImageEditingViewModel

    var body: some View {
        if !viewModel.textBoxes.isEmpty {
            ZStack {
                VStack {
                    TextField("Введите текст здесь", text: $viewModel.textBoxes[viewModel.currentTextIndex].text)
                        .font(.system(size: 18, weight: viewModel.textBoxes[viewModel.currentTextIndex].isBold ? .bold : .regular))
                        .foregroundColor(viewModel.textBoxes[viewModel.currentTextIndex].textColor)

                    HStack {
                        Button(action: {
                            viewModel.textBoxes[viewModel.currentTextIndex].isAdded = true
                            viewModel.canvasView.becomeFirstResponder()
                            withAnimation {
                                viewModel.isEditing = false
                            }
                        }, label: {
                            Text("Добавить")
                                .buttonLabelModifier()
                        })

                        Button(action: {
                            viewModel.cancelTextView()
                        }, label: {
                            Text("Отмена")
                                .buttonLabelModifier()
                        })
                    }

                    HStack {
                        ColorPicker("", selection: $viewModel.textBoxes[viewModel.currentTextIndex].textColor)
                            .labelsHidden()
                            .padding(5)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)

                        Button(action: {
                            viewModel.textBoxes[viewModel.currentTextIndex].isBold.toggle()
                        }, label: {
                            Text(viewModel.textBoxes[viewModel.currentTextIndex].isBold ? "Normal" : "Bold")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black)
                                .cornerRadius(8)
                        })
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let box = TextBox(id: "1", text: "Test text", isBold: false, offset: CGSize(width: 0, height: 0), lastOffset: CGSize(width: 0, height: 0), textColor: Color.green, isAdded: false)
    let viewModel = ImageEditingViewModel()
    viewModel.textBoxes.append(box)
    return TextEditingFooter()
        .environmentObject(viewModel)
}

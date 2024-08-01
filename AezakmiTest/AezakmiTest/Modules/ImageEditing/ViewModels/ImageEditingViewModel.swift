//
//  myViewModel.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//

import SwiftUI
import PencilKit
import PhotosUI

final class ImageEditingViewModel: ObservableObject {
    @Published var canvasView = PKCanvasView()
    @Published var image: UIImage?
    @Published var shareImage: UIImage?
    @Published var toolPicker = PKToolPicker()
    @Published var textBoxes: [TextBox] = []
    @Published var isEditing: Bool = false
    @Published var currentTextIndex: Int = 0
    @Published var rect: CGRect = .zero
    @Published var showAlert: Bool = false
    @Published var message: String = ""
    
    func cancelImageEditing() {
        canvasView = PKCanvasView()
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        image = nil
        textBoxes = []
    }

    func cancelTextView() {
        canvasView.becomeFirstResponder()
        withAnimation {
            isEditing = false
        }
        if !textBoxes[currentTextIndex].isAdded {
            textBoxes.removeLast()
        }
    }

    func exportImage(isShared: Bool) {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        canvasView.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        let swiftView = ZStack {
            ForEach(textBoxes) { box in
                Text(box.text)
                    .fontWeight(box.isBold ? .bold : .regular)
                    .foregroundStyle(box.textColor)
                    .offset(box.offset)
            }
        }

        let controller = UIHostingController(rootView: swiftView).view!
        controller.frame = rect

        controller.backgroundColor = .clear
        canvasView.backgroundColor = .clear

        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)

        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if isShared {
            if let image = generatedImage?.pngData() {
                shareImage = UIImage(data: image)!
            }
        } else {
            if let image = generatedImage?.pngData() {
                UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
                self.message = "Успешно сохранено"
                self.showAlert.toggle()
            }
        }
    }
}

//
//  ImageFilterView.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 31.07.2024.
//

import SwiftUI

struct ImageFilterView: View {
    @StateObject private var viewModel = ImageFilterViewModel()
    var image: UIImage

    var body: some View {
        VStack {
            if let image = viewModel.filteredImage ?? viewModel.originalImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
            }

            HStack {
                ForEach(viewModel.availableFilters(), id: \.name) { filter in
                    Button(action: {
                        viewModel.applyFilter(filter)
                    }, label: {
                        Text(filter.name)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 8))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black)
                            }
                    })
                }
            }
            .padding(.vertical)


            Button(action: {
                viewModel.saveImageToGallery()
            }, label: {
                Text("Сохранить")
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                    }
            })
        }
        .padding()
        .onAppear {
            viewModel.originalImage = image
        }
    }
}

#Preview {
    ImageFilterView(image: .add)
}

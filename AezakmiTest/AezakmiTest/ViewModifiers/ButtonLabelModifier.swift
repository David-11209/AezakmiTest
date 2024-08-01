//
//  ButtonLabelModifer.swift
//  AezakmiTest
//
//  Created by Давид Васильев on 01.08.2024.
//
import SwiftUI

struct ButtonLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
            content
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black)
            }
    }
}

extension View {
    func buttonLabelModifier() -> some View {
        modifier(ButtonLabelModifier())
    }
}


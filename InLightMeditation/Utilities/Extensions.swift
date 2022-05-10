//
//  Extensions.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 5/9/22.
//

import Foundation
import SwiftUI


extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

struct GreenBorderTextField: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("lightgreen"), lineWidth: 1)
        )
    }
}

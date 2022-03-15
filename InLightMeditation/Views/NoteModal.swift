//
//  NoteModal.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 3/14/22.
//

import SwiftUI
import Combine

struct NoteModal: View {
    let screenSize = UIScreen.main.bounds
    @Binding var isShown: Bool
    @State var text: String
    @State var emoji: String
    var onDone: (String, String) -> Void = { _,_  in }
    
    var body: some View {
        VStack(spacing: 40) {
            Text("describe your experience")
                .font(.headline)
            TextEditor(text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(5.0)
                .padding()
                .frame(height: 200)
            HStack(spacing: 20) {
                Button("🌞") {
                    self.emoji = "sun_with_face"
                }
                Button("🌤️") {
                    self.emoji = "sun_behind_small_cloud"
                }
                Button("⛅") {
                    self.emoji = "sun_behind_large_cloud"
                }
                Button("🌩️") {
                    self.emoji = "cloud_with_lightening"
                }
                Button("⚡") {
                    self.emoji = "lightening_bolt"
                }
            }
            HStack(spacing: 20) {
                Button("Okay") {
                    self.isShown = false
                    self.onDone(self.text, self.emoji)
                    self.endEditing()
                }
                .buttonStyle(SaveButtonStyle())
            }
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(
            color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)),
            radius: 6, x: -9, y: -9
        )
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}



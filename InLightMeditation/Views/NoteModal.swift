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
    @State var stars: Int
    var onDone: (String, Int) -> Void = { _,_  in }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("reflections?")
                .font(.headline)
            TextEditor(text: $text)
                .padding(16)
                .frame(height: 200)
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
                .background(Color("lightgray"))
                .cornerRadius(8)
            Text("how in tune with your sense were you?")
                .font(.headline)
                .padding(.top, 6)
            Text("\(renderStars())")
                .font(.headline)
                .padding(.top, 6)
                .frame(height: 40)
                .padding(.bottom, 6)
            HStack(spacing: 10) {
                Button("⭐") {
                    self.stars = 1
                }
                Button("⭐") {
                    self.stars = 2
                }
                Button("⭐") {
                    self.stars = 3
                }
                Button("⭐") {
                    self.stars = 4
                }
                Button("⭐") {
                    self.stars = 5
                }
            }
            HStack {
                Button(action: {
                    self.isShown = false
                    self.onDone(self.text, self.stars)
                    self.endEditing()
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16))
                }
                .buttonStyle(SaveButtonStyle())
            }
        }
        .padding(20)
        .frame(width: 300)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(
            color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)),
            radius: 6, x: -9, y: -9
        )
    }
    func renderStars() -> String{
        if (self.stars < 1) {
            return ""
        }
        var starsRender = ""
        for i in 1...self.stars {
            starsRender += "⭐"
        }
        return starsRender
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}



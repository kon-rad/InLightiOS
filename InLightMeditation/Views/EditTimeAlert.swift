//
//  EdittextAlert.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/4/21.
//

import SwiftUI
import Combine

struct EditTimeAlert: View {
    
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            TextField("", text: $text, onCommit:  {
                UIApplication.shared.endEditing()
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 80)
            HStack(spacing: 20) {
                Button("Save") {
                    self.isShown = false
                    print("save, text: ", self.text)
                    self.onDone(self.text)
                    self.endEditing()
                }
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                    self.endEditing()
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.3)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

struct EditTimeAlert_Previews: PreviewProvider {
    static var previews: some View {
        EditTimeAlert(title: "Minutes", isShown: .constant(true), text: .constant("10"));
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

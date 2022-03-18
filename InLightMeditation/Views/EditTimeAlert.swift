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
                .keyboardType(.numberPad)
                .onReceive(Just(text), perform: self.numericValidator)
//                .onReceive(Just(text)) { newValue in
//                    let filtered = newValue.filter { "0123456789".contains($0) }
//                    if filtered != newValue {
//                        self.text = filtered
//                    }
                .textFieldStyle(PlainTextFieldStyle()) 
                .padding(8)
                .keyboardType(.numberPad)
                .frame(width: 80)
                .background(Color("lightgray"))
                .cornerRadius(16)
            HStack(spacing: 20) {
                Button("save") {
                    self.isShown = false
                    self.onDone(self.text)
                    self.endEditing()
                }
                .buttonStyle(SaveButtonStyle())
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                    self.endEditing()
                }
                .buttonStyle(CancelButtonStyle())
            }
        }
        .padding()
        .frame(width: 200, height: 200)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
        
    func numericValidator(newValue: String) {
        var validText = newValue
        if validText.count > 3 {
            validText = String(validText.dropLast())
        }
        if validText.range(of: "^\\d+$", options: .regularExpression) != nil {
            self.text = validText
        } else if !self.text.isEmpty {
            self.text = String(validText.prefix(self.text.count - 1))
        }
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

//
//  DeleteProfileModal.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 6/1/22.
//

import SwiftUI

struct DeleteProfileModal: View {
    
    let screenSize = UIScreen.main.bounds
    @Binding var isShown: Bool
    var onDelete: () -> Void = { }
    
    
    var body: some View {
        VStack(spacing: 10) {
            Text("are you sure you want to delete your profile?")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("this action can't be undone")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 6)
            
            HStack(spacing: 20) {
                HStack {
                    Button(action: {
                        self.onDelete()
                    }) {
                        Text("delete")
                            .font(.system(size: 16))
                            .foregroundColor(Color("danger"))
                    }
                    .buttonStyle(CancelButtonStyle())
                }
                HStack {
                    Button(action: {
                        self.closeModal()
                    }) {
                        HStack {
                            Text("stick with it")
                                .font(.system(size: 16))
                        }
                    }
                    .buttonStyle(SaveButtonStyle())
                }
            }
            .padding(.top, 60)
        }
        .padding()
        .frame(width: 300)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)
    }
    
    func closeModal() {
        self.isShown = false
        UIApplication.shared.endEditing()
    }
}

struct DeleteProfileModal_Previews: PreviewProvider {
    static var previews: some View {
        DeleteProfileModal(isShown: .constant(false))
    }
}

//
//  EditProfileView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 5/6/22.
//

import SwiftUI

struct EditProfileView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    @State private var username: String = ""
    @State private var motivation: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    returnToMenu()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward.circle")
                            .imageScale(.large)
                            .onTapGesture {
                                returnToMenu()
                            }
                            .foregroundColor(Color("textblack"))
                    }
                }
                .padding(.leading, 30)
            }
            Image("user_icon")
                .resizable()
                .frame(width: 70, height: 70.0)
                .padding(.top, 50)
            Button(action: { uploadPhoto() }) {
                Text("Upload Image")
                    .padding(.top, 12)
            }
            TextField("User name", text: $username)
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 40, alignment: .center)
                .animation(nil)
            Text("Why do I want to practice meditation?")
                .padding(.top, 12)
            TextField("motivation", text: $motivation)
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 40, alignment: .center)
                .animation(nil)
        }
        .padding(.leading, 25)
        .padding(.trailing, 25)
    }
    func returnToMenu() {
        self.viewRouter.currentPage = .menu
    }
    func uploadPhoto() {
        print("uploading photo")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewRouter: ViewRouter())
    }
}

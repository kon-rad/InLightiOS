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
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    @EnvironmentObject var session: FirebaseSession
    
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
                Spacer()
            }
            VStack {
                Image(uiImage: self.image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 240, maxHeight: 240)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color("lightyellow"), lineWidth: 3))
                Button(action: {
                    self.isShowPhotoLibrary = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 16))
     
                        Text("photo library")
                            .font(.system(size: 16))
                    }
                    .frame( minHeight: 0, maxHeight: 40)
                    .background(Color("mediumgreen"))
                    .foregroundColor(.white)
                    .cornerRadius(18)
                    .padding(.horizontal)
                }
            }
            TextField("User name", text: $username)
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 40, alignment: .center)
                .animation(nil)
            Text("Why I want to practice meditation?")
                .padding(.top, 12)
            TextField("motivation", text: $motivation)
                .font(.system(size: 15, weight: .regular, design: .default))
                .keyboardType(.default)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 40, alignment: .center)
                .animation(nil)
            Button(action: { self.saveProfile() }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
 
                    Text("save")
                        .font(.system(size: 16))
                }
                .frame( minHeight: 0, maxHeight: 40)
                .background(Color("mediumgreen"))
                .foregroundColor(.white)
                .cornerRadius(18)
                .padding(.horizontal)
                
            }
        }
        .padding(.leading, 25)
        .padding(.trailing, 25)
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
    }
    func saveProfile() {
        print("save profile")
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

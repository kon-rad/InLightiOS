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
    @State private var updatedAvatar: Bool = false
    
    @EnvironmentObject var session: FirebaseSession
    
    @EnvironmentObject var storage: StorageManager
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    returnToMenu()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                returnToMenu()
                            }
                            .foregroundColor(Color("textblack"))
                    }
                }
                Spacer()
            }
            .onTapGesture {
                self.endTextEditing()
            }
            VStack {
                if (updatedAvatar) {
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 140, maxHeight: 140)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color("lightyellow"), lineWidth: 3))
                } else {
                    if (self.session.hasAvatar) {
                        Image(uiImage: self.session.avatar!)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 140, maxHeight: 140)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color("lightyellow"), lineWidth: 3))
                    } else {
                        Image("user_icon")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 100, maxHeight: 100)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color("lightyellow"), lineWidth: 3))
                    }
                }
                Button(action: {
                    self.isShowPhotoLibrary = true
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 16))
                        Text("upload photo")
                            .font(.system(size: 16))
                    }
                }
                .buttonStyle(SaveButtonStyle())
                .padding(.top, 6)
            }
            .onTapGesture {
                self.endTextEditing()
            }
            VStack(alignment: .leading) {
                Text("username:")
                    .padding(.top, 28)
                TextField("User name", text: $username)
                    .submitLabel(.done)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .keyboardType(.default)
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 40, alignment: .center)
                    .textFieldStyle(GreenBorderTextField())
                Text("I practice meditation because:")
                    .padding(.top, 12)
                TextEditor(text: $motivation)
                    .submitLabel(.search)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .keyboardType(.default)
                    .frame(height: 100)
                    .padding(4)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("lightgreen"), lineWidth: 1))
            }
            .onTapGesture {
                self.endTextEditing()
            }
            Button(action: { self.saveProfile() }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                    Text("save")
                        .font(.system(size: 16))
                }
            }
            .buttonStyle(SaveButtonStyle())
            .padding(.top, 20)
            Spacer()
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .padding(.leading, 35)
        .padding(.trailing, 35)
        .padding(.top, 60)
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: self.$image, updatedAvatar: self.$updatedAvatar, sourceType: .photoLibrary)
        }
        .onAppear {
            if (self.session.username != nil) {
                self.username = self.session.username!
            }
            if (self.session.motivation != nil) {
                self.motivation = self.session.motivation!
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    func saveProfile() {
        session.updateProfile(username: self.username, motivation: self.motivation)
        if (session.session != nil) {
            guard let userId = session.session?.uid else { return }
            if (self.updatedAvatar) {
                storage.upload(image: self.image, userId: userId) { (status) in
                    print("save image status: ", status)
                    self.viewRouter.currentPage = .profile
                }
            }
        }
    }
    func returnToMenu() {
        self.viewRouter.currentPage = .menu
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewRouter: ViewRouter())
    }
}

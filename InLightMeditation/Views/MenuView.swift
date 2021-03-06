//
//  MenuView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 5/5/22.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var session: FirebaseSession
    
    @ObservedObject var viewRouter: ViewRouter
    
    @State var showDeleteProfileModal: Bool = false
    
    var body: some View {
        ZStack {
            Color("ultralightyellow")
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        self.returnToProfile()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    self.returnToProfile()
                                }
                                .foregroundColor(Color("textblack"))
                        }
                    }
                    .padding(.leading, 30)
                    Spacer()
                }
                List {
                    HStack {
                        Image("signout")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 22, height: 22)
                            .padding(.trailing, 4)
                        Text("Sign Out")
                            .onTapGesture {
                                self.signOut()
                            }
                    }
                    HStack {
                        Image("edit")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding(.trailing, 4)
                        Text("Edit Profile")
                            .onTapGesture {
                                self.viewRouter.currentPage = .editProfile
                            }
                    }
                    Spacer()
                }
                .listStyle(SidebarListStyle())
                HStack {
                    Image("user-delete")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(.trailing, 4)
                    Text("Delete Profile")
                        .onTapGesture {
                            self.showDeleteProfileModal = true
                        }
                }
                .padding(.leading, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 60)
            .animation(Animation.easeIn.delay(0.25))
            .transition(.slide)
            DeleteProfileModal(
                isShown: self.$showDeleteProfileModal,
                onDelete: {
                    self.session.deleteUser()
                }
            )
        }
    }
    func signOut() {
        session.signOut()
    }
    func returnToProfile() {
        self.viewRouter.currentPage = .profile
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(viewRouter: ViewRouter())
    }
}

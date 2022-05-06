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
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.returnToProfile()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward.circle")
                            .imageScale(.large)
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
                Text("Sign Out")
                    .onTapGesture {
                        self.signOut()
                    }
                Text("Edit Profile")
                    .onTapGesture {
                        self.viewRouter.currentPage = .editProfile
                    }
                Text("Info Center")
                    .onTapGesture {
                        print("Info Center")
                    }
            }
            .background(Color("lightyellow"))
            .listStyle(SidebarListStyle())
        }
        .padding(.top, 50)
        .animation(Animation.easeIn.delay(0.25))
        .transition(.slide)
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

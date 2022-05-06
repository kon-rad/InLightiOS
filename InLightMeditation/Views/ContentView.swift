//
//  ContentView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Meditation.entity(), sortDescriptors: [])
    
    var meditations: FetchedResults<Meditation>
    
    @StateObject var viewRouter: ViewRouter
    
    @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        Group {
            GeometryReader { geometry in
                VStack {
                    if !session.isLoggedIn {
                        LoginView()
                    } else {
                        Spacer()
                        switch viewRouter.currentPage {
                            case .timer:
                                TimerView(viewRouter: viewRouter)
                            case .profile:
                                Profile(viewRouter: viewRouter)
                            case .timerProgress:
                                TimerProgress()
                            case .menu:
                                MenuView(viewRouter: viewRouter)
                                    .transition(.move(edge: .trailing))
                            case .editProfile:
                                EditProfileView(viewRouter: viewRouter)
                                    .transition(.move(edge: .trailing))
                        }
                        Spacer()
                        Group {
                            ZStack {
                                HStack {
                                    Spacer()
                                    TabBarIcon(viewRouter: viewRouter, page: .timer, width: geometry.size.width/5, height: 120, icon: "meditation_icon", tabName: "Meditate")
                                    Spacer()
                                    TabBarIcon(viewRouter: viewRouter, page: .profile, width: geometry.size.width/5, height: 120, icon: "user_icon", tabName: "Profile")
                                    Spacer()
                                }
                                .padding(.vertical, 18)
                                .overlay(Rectangle().frame(width: nil, height: 2, alignment: .top).foregroundColor(Color("mediumgreen")), alignment: .top)
                            }
                        }
                        .background(Color("lightgreen"))
                    }
                }
                .background(Color("ultralightyellow"))
                .ignoresSafeArea()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewRouter: ViewRouter())
        }
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let page: Page
    
    let width, height: CGFloat
    let icon: String
    let tabName: String
    
    var body: some View {
        VStack {
            Image(self.icon)
                .frame(width: 30, height: 30.0)
            Text(tabName)
                .font(.footnote)
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            viewRouter.currentPage = self.page
        }
    }
}

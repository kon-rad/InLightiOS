//
//  ContentView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        Group {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    switch viewRouter.currentPage {
                        case .timer:
                            TimerView()
                        case .profile:
                            Profile()
                    }
                    Spacer()
                    Group {
                        ZStack {
                            HStack {
                                Spacer()
                                Spacer()
                                TabBarIcon(viewRouter: viewRouter, page: .timer, width: geometry.size.width/5, height: 120, icon: "meditation_icon", tabName: "Meditate")
                                Spacer()
                                TabBarIcon(viewRouter: viewRouter, page: .profile, width: geometry.size.width/5, height: 120, icon: "user_icon", tabName: "Profile")
                                Spacer()
                            }
                            .padding(.bottom, 18)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
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

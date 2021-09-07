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
                ZStack {
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, page: .timer, width: geometry.size.width/5, height: geometry.size.height/28, icon: "meditation_icon", tabName: "Meditate")
                        TabBarIcon(viewRouter: viewRouter, page: .profile, width: geometry.size.width/5, height: geometry.size.height/28, icon: "user_icon", tabName: "Profile")
                    }
                }
            }
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
            Spacer()
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            viewRouter.currentPage = self.page
        }
    }
}

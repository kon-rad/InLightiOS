//
//  SplashScreenView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI

struct SplashScreenView: View {
    var shouldTransition = true
    @State var isActive: Bool = false
    var animationDuration = 1.0
    var animationDelay = 2.5
    
    var body: some View {
        if isActive {
            ContentView(viewRouter: ViewRouter())
        } else {
            inactiveView
                .onAppear(perform: gotoContentView)
        }
    }
    
    var inactiveView: some View {
        ZStack {
            Image("bg-sunset")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 6)
                .padding(.all, -46)
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("InLight Meditation")
                        .font(Font.custom("NunitoSans-Bold", size: 34))
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30.0)
                        .frame(width: 200.0)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 10)
                        .frame(width: 120, height: 120, alignment: .center)
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    func gotoContentView() {
        if shouldTransition {
            withAnimation(
                .easeInOut(duration: animationDuration)
                .delay(animationDelay)
            ) {
                isActive = true
            }
        }
    }
}

public struct SplashScreenView_Previews: PreviewProvider {
    public static var previews: some View {
        SplashScreenView(shouldTransition: false, isActive: false)
            .previewLayout(.fixed(width: 300, height: 650))
            .frame(width: 300, height: 650)
    }
}

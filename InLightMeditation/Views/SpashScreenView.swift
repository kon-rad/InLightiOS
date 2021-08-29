//
//  SpashScreenView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI

struct SpashScreenView: View {
    @State var isActive: Bool = false
    @State var animation = 0.0
    @State var percent = 0.0
    var uAnimationDuration: Double { return 1.0 }
      
    func handleAnimations() {
      runAnimationPart1()
    }

    func runAnimationPart1() {
      withAnimation(.easeIn(duration: uAnimationDuration)) {
        percent = 1
      }
    }
    var body: some View {
        if self.isActive {
            TimerView()
        }
        ZStack {
            Image("bg-sunset")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 6)
                .padding(.all, -10)
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("InLight Meditation")
                        .font(Font.custom("NunitoSans-Bold", size: 34))
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30.0/*@END_MENU_TOKEN@*/)
                        .frame(width: 200.0)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90.0, alignment: .center)
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear(perform: {
            self.gotoTimerView(time: 2.5)
        })
    }
    
    func gotoTimerView(time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
            self.isActive = true
        }
    }
}

struct SpashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SpashScreenView()
        }
    }
}

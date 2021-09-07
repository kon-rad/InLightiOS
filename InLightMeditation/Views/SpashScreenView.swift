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
        withAnimation {
            return Group {
                if self.isActive {
                    withAnimation {
                        ContentView(viewRouter: ViewRouter())
                            .animation(.easeInOut(duration: 1))
                    }
                } else {
                    withAnimation {
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
                                    Image("sitting_posture")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.top, 10)
                                        .frame(width: 220, height: 220.0, alignment: .center)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        .onAppear(perform: {
                            self.gotoContentView(time: 2.5)
                        })
                        .animation(.easeInOut(duration: 1))
                    }
                }
            }
        }
    }
    
    func gotoContentView(time: Double) {
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

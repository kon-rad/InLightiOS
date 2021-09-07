//
//  NavView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI

struct NavView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    VStack {
                        HStack {
                            HStack {
                                Spacer()
                                Spacer()
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                NavigationLink(
                                    destination: TimerView(),
                                    label: {
                                        Image("meditation_icon")
                                            .frame(width: 30, height: 30.0)
                                    })
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                NavigationLink(
                                    destination: Profile(),
                                    label: {
                                        Image("user_icon")
                                            .frame(width: 30, height: 30.0)
                                    })
                                Spacer()
                            }
                        }
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
                .padding()
            }
            .frame(width: geometry.size.width, height: 76.0)
        }
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}

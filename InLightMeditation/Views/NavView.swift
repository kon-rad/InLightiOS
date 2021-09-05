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
                VStack {
                    HStack {
                        HStack {
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Image("meditation_icon")
                                .frame(width: 30, height: 30.0)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Image("user_icon")
                                .frame(width: 30, height: 30.0)
                            Spacer()
                        }
                    }
                }.navigationBarTitle("")
                .navigationBarHidden(true)
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

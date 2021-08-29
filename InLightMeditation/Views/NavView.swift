//
//  NavView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI

struct NavView: View {
    var body: some View {
        HStack {
            Spacer()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Spacer()
            Text("profile")
            Spacer()
        }
        .frame(width: 50, height: 30)
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}

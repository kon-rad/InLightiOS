//
//  TimerView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI

struct TimerView: View {
    @State var time: String = "10"
    @State var editTime: Bool = false
    @State var isSoundOn: Bool = true
    @State var isRunning: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(self.time):00")
                        .font(Font.system(size: 38, design: .default))
                        .frame(width: 140, height: 100, alignment: .center)
                        .onTapGesture {
                            self.editTime = true
                        }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        print("tapped")
                    }) {
                        HStack {
                            Text("start")
                        }
                    }.buttonStyle(StartButtonStyle())
                    Button(action: {
                        print("sound")
                    }) {
                        Image("volume-up-line")
                            .resizable()
                            .foregroundColor(Color.black)
                            .scaledToFit()
                            .padding(.leading, 20)
                            .frame(width: 50, height: 30.0, alignment: .center)
                    }
                    Spacer()
                }
                Spacer()
                NavView()
                    .frame(height: 76)
            }
            EditTimeAlert(title: "Minutes", isShown: self.$editTime, text: $time, onDone: { text in
                print("onDone", text)
                self.time = text
            })
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView()
        }
    }
}

struct StartButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(.all, 18.0)
            .background(Color.green)
            .cornerRadius(50.0)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}


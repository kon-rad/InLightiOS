//
//  Profile.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import SwiftUI

struct Profile: View {
    
    @EnvironmentObject var session: FirebaseSession
    
    @State var currentStreak: Int16 = 0
    @State var bestStreak: Int16 = 0
    @State var totalMinutes: Int16 = 0
    
    init() {
        UINavigationBar.setAnimationsEnabled(false)
    }
    var body: some View {
        NavigationView {
            VStack {
            if session.isLoggedIn {
                Button(action: { signOut() }) {
                    Text("sign out")
                }
            }
            Spacer()
                ScrollView(showsIndicators: false) {
                VStack {
                    Image("user_icon")
                        .resizable()
                        .frame(width: 70, height: 70.0)
                        .padding(.top, 50)
                    HStack {
                        Spacer()
                        VStack {
                            Text("\(String(self.session.currentStreak))")
                                .font(.headline)
                                .frame(width: 60)
                            Text("current streak")
                                .font(.subheadline)
                        }
                        VStack {
                            Text("\(String(self.session.bestStreak ?? 0))")
                                .font(.headline)
                                .frame(width: 60)
                            Text("best streak")
                                .font(.subheadline)
                        }
                        VStack {
                            Text("\(String(self.session.totalMinutes ?? 0))")
                                .font(.headline)
                                .frame(width: 60)
                            Text("total minutes")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    Spacer()
                    VStack {
                        Text("current streak")
                        Spacer()
                        Spacer()
                        CurrentStreak(currentStreak: self.session.currentStreak)
                    }
                    .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(Color(red: 244 / 255, green: 244 / 255, blue: 244 / 255))
                    .cornerRadius(15)
                    VStack {
                        Text("Meditations List:")
                            .padding(.top, 18)
                        VStack {
                            ForEach(self.session.items) { meditation in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(meditation.startTime)")
                                            .font(.subheadline)
                                        Text("\(meditation.duration)")
                                            .font(.subheadline)
                                        Text("\(meditation.note)")
                                            .font(.subheadline)
                                        Text("\(meditation.emoji)")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                }
                                .frame(height: 60)
                            }
                            .padding(.top, 10)
                        }
                        Spacer()
                    }
                }
                .onAppear() {
                    session.getSessions()
                    print("onAppear of Profile: ", self.session.items)
                }
                .animation(nil)
                .padding()
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            }
            .animation(nil)
        }
    }
    func signOut() {
        session.signOut()
    }
    func renderTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dateString = formatter.string(from: date)
        return "Start time: \(dateString)"
    }
    func renderDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateString = formatter.string(from: date)
        return "\(dateString)"
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

extension Color {
    static let bgGray = Color(hue: 0, saturation: 0, brightness: 96, opacity: 100)
}

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
    @State private var expandNote: [UUID: Bool] = [:]
    
    init() {
        UINavigationBar.setAnimationsEnabled(false)
        UIScrollView.appearance().backgroundColor = UIColor(Color("ultralightyellow"))
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color("ultralightyellow").ignoresSafeArea()
                VStack {
                    if session.isLoggedIn {
                        HStack {
                            Text("signed in as: \(session.email)")
                            Button(action: { signOut() }) {
                                Text("sign out")
                            }
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
                                    ForEach(self.session.items, id: \.self) { meditation in
                                        HStack {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text("\(self.formatStartTime(startTime: meditation.startTime))")
                                                        .font(.headline).bold()
                                                    Text("\(Emoji.renderEmoji(emoji: meditation.emoji))")
                                                        .font(.system(size: 16.0))
                                                    Spacer()
                                                    Text("\(meditation.duration) min")
                                                        .font(.system(size: 12.0))
                                                }
                                                Text("\(self.expandNote[meditation.id] == true ? meditation.note : "\(String(meditation.note.prefix(40))) ...")")
                                                    .font(.system(size: 16.0))
                                            }
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 1)){
                                                    if expandNote[meditation.id] != nil {
                                                        self.expandNote[meditation.id] = nil
                                                    } else {
                                                        self.expandNote[meditation.id] = true
                                                    }
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                    .padding(.top, 10)
                                }
                                Spacer()
                            }
                        }
                        .onAppear() {
                            session.getSessions()
                        }
                        .animation(nil)
                        .padding()
                        .ignoresSafeArea()
                    }
                    .listStyle(PlainListStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .background(Color("ultralightyellow"))
                }
                .animation(nil)
                .background(Color("ultralightyellow"))
            }
        }
        .onDisappear {
            UIScrollView.appearance().backgroundColor = UIColor(Color.gray.opacity(0))
         }
        .animation(nil)
    }
    func formatStartTime(startTime: String) -> String {
        let dateFormatterGet = DateFormatter()
        
        dateFormatterGet.dateFormat = "YY, MMM d, HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd"

        var returnValue = "unknown"
        if let date = dateFormatterGet.date(from: startTime) {
            returnValue = dateFormatterPrint.string(from: date)
        }
        return returnValue
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

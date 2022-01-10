//
//  Profile.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import SwiftUI

struct Profile: View {
//    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(entity: Meditation.entity(), sortDescriptors: [])
    
//    var meditations: FetchedResults<Meditation>
    
    @ObservedObject var session = FirebaseSession()
    
    @State var currentStreak: Int16 = 0
    @State var bestStreak: Int16 = 0
    @State var totalMinutes: Int16 = 0
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    HStack {
                        ZStack {
                            Text("login/signup")
                            NavigationLink(destination: LoginView()) {
                                EmptyView()
                            }.buttonStyle(PlainButtonStyle())
                        }
                        Button(action: { signOut() }) {
                            Text("sign out")
                        }
                    }
                    Spacer()
                    Spacer()
                    Image("user_icon")
                        .resizable()
                        .frame(width: 70, height: 70.0)
                        .padding(.top, 50)
                    HStack {
                        Spacer()
                        VStack {
                            Text("\(String(self.currentStreak))")
                                .font(.headline)
                                .frame(width: 60)
                            Text("current streak")
                                .font(.subheadline)
                        }
                        VStack {
                            Text("\(String(self.bestStreak ?? 0))")
                                .font(.headline)
                                .frame(width: 60)
                            Text("best streak")
                                .font(.subheadline)
                        }
                        VStack {
                            Text("\(String(self.totalMinutes ?? 0))")
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
                        CurrentStreak()
                    }
                    .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
                    .frame(maxWidth: .infinity)
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
//                                        Text("Duration: \(meditation.minutes) minutes - \(self.renderTime(date: meditation.startTime!))")
//                                            .font(.subheadline)
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
//                    let last = meditations.last
//                    self.currentStreak = last?.currentStreak ?? 0
//                    self.bestStreak =  last?.bestStreak ?? 0
//                    self.totalMinutes =  last?.totalMinutes ?? 0
//                    print("last", last)
                    session.getSessions()
                }
            }
            .listStyle(PlainListStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
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

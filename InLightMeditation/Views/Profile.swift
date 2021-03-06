//
//  Profile.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import SwiftUI

struct Profile: View {
    
    @EnvironmentObject var session: FirebaseSession
    
    @ObservedObject var viewRouter: ViewRouter
    
    @State var currentStreak: Int16 = 0
    @State var bestStreak: Int16 = 0
    @State var totalMinutes: Int16 = 0
    @State private var expandNote: [UUID: Bool] = [:]
    
    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
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
                            Spacer()
                            Spacer()
                            Button(action: { showMenu() }) {
                                Image("menu")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 35)
                                    .padding(.top, 10)
                            }
                        }
                    }
                    Spacer()
                    ScrollView(showsIndicators: false) {
                        VStack {
                            if (self.session.hasAvatar) {
                                Image(uiImage: self.session.avatar!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 196, maxHeight: 196)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color("lightyellow"), lineWidth: 3))
                            } else {
                                Image("user_icon")
                                    .resizable()
                                    .frame(width: 70, height: 70.0)
                                    .padding(.top, 50)
                            }
                            if (session.username != nil) {
                                Text(session.username!)
                                    .padding(.top, 18)
                                    .font(.subheadline)
                            }
                            if (session.motivation != nil) {
                                Text("I practice meditation because:")
                                    .padding(.top, 8)
                                    .padding(.bottom, 2)
                                    .font(Font.subheadline.weight(.bold))
                                Text(session.motivation!)
                                    .font(.subheadline)
                                    .padding(.bottom, 4)
                            }
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
                                                    Text("\(renderStars(stars: meditation.stars))")
                                                        .font(.system(size: 16.0))
                                                    Spacer()
                                                    Text("\(meditation.duration) min")
                                                        .font(.system(size: 12.0))
                                                }
                                                Text(self.renderNoteText(id: meditation.id, note: meditation.note))
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
    func renderStars(stars: Int) -> String{
        if (stars < 1) {
            return ""
        }
        var starsRender = ""
        for i in 1...stars {
            starsRender += "???"
        }
        return starsRender
    }
    func showMenu() {
        self.viewRouter.currentPage = .menu
    }
    func renderNoteText(id: UUID, note: String) -> String {
        if self.expandNote[id] == true {
           return note
        }
        if note.count > 32 {
            return "\(String(note.prefix(40))) ..."
        }
        return "\(String(note.prefix(40)))"
//        ((String(meditation.note.count) > 100 ? "\(String(meditation.note.prefix(40))) ..."
//                    : String(meditation.note.prefix(40)))"
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

public struct Profile_Previews: PreviewProvider {
    public static var previews: some View {
        Profile(viewRouter: ViewRouter())
            .environmentObject(FirebaseSession())
    }
}

extension Color {
    static let bgGray = Color(hue: 0, saturation: 0, brightness: 96, opacity: 100)
}

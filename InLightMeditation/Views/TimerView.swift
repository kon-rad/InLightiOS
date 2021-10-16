//
//  TimerView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct TimerView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Meditation.entity(), sortDescriptors: [])

    var meditations: FetchedResults<Meditation>
    
    @State var time: String = "10"
    @State var editTime: Bool = false
    @State var isSoundOn: Bool = true
    
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    
    @State var timerIsRunning: Bool = false
    @State var timer: Timer? = nil
    @State var startTime: Date? = nil
    @State var initialTime: String? = nil
    
    @StateObject var viewRouter: ViewRouter
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        if self.timerIsRunning {
                ZStack {
                    HStack {
                        Spacer()
                        Text(renderTime())
                            .font(Font.system(size: 38, design: .monospaced))
                            .frame(width: 160, height: 100, alignment: .center)
                            .padding(.all, 10)
                            .onTapGesture {
                                self.startTimer()
                            }
                            .animation(nil)
                        Spacer()
                    }
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
                }
                .frame(width: screenWidth, height: screenHeight)
                .background(Color(hex: "CDD9E3").ignoresSafeArea(.all))
                .onTapGesture {
                    self.startTimer()
                }
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
        } else {
            ZStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(renderTime())
                            .font(Font.system(size: 38, design: .monospaced))
                            .frame(width: 160, height: 100, alignment: .center)
                            .padding(.all, 10)
                            .onTapGesture {
                                if !self.timerIsRunning {
                                    self.editTime = true
                                }
                            }
                            .animation(nil)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.startTimer()
                        }) {
                            HStack {
                                Text(!self.timerIsRunning ? "start" : "stop")
                            }
                        }
                        .buttonStyle(StartButtonStyle())
                        Button(action: {
                            print("sound")
                            self.isSoundOn.toggle()
                        }) {
                            Image(self.isSoundOn ? "volume-up-line" : "sound_off")
                                .resizable()
                                .foregroundColor(Color.black)
                                .scaledToFit()
                                .padding(.leading, 20)
                                .frame(width: 50, height: 30.0, alignment: .center)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                EditTimeAlert(title: "Minutes", isShown: self.$editTime, text: $time, onDone: { text in
                    print("onDone", text)
                    self.time = text
                })
            }
        }
    }
    func renderTime() -> String {
        if !self.timerIsRunning {
            return "\(self.time):00"
        } else {
            return "\(self.minutes < 10 ? "0\(self.minutes)" : String(self.minutes)):\(self.seconds < 10 ? "0\(self.seconds)" : String(self.seconds))"
        }
    }
    func startTimer() {
        if self.timerIsRunning {
            self.stopTimer()
            return
        }
        self.viewRouter.currentPage = .timerProgress
        self.resetTimer()
        self.timerIsRunning = true
        self.minutes = Int(self.time)!
        self.initialTime = self.time
        self.startTime = Date()
        self.attemptSound()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
            // todo: make sure to remove the 'true' statement - it's for development purposes only
            if seconds == 0 && self.minutes == 0 {
                print("timer completed!")
                self.handleTimerCompleted()
                self.attemptSound()
                self.stopTimer()
                self.resetTimer()
            }
            if self.seconds == 0 {
                self.seconds = 59
                if self.minutes == 0 {
                    self.minutes = 59
                    self.hours -= 1
                } else {
                    self.minutes -= 1
                }
            } else {
                self.seconds -= 1
            }
        }
    }
    func stopTimer() {
        self.timerIsRunning = false
        self.timer?.invalidate()
        self.timer = nil
    }
    func resetTimer() {
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
    }
    func attemptSound() {
        if self.isSoundOn {
            print("playing sound")
            Sounds.playSounds(soundFile: "tibetan_bowl_1.m4a")
        }
    }
    func handleTimerCompleted() {
        let newMeditation = Meditation(context: viewContext)
        newMeditation.startTime = self.startTime
        newMeditation.endTime = Date()
        newMeditation.minutes = Int16(self.initialTime!)!
        newMeditation.id = UUID()
        let last = meditations.last
        if last == nil {
            newMeditation.currentStreak = 1
            newMeditation.bestStreak = 1
            newMeditation.totalMinutes = Int16(self.initialTime!)!
        } else {
            print("min: ", Int16(self.initialTime!)!)
            var currentStreak = last?.currentStreak ?? 0
            if (last?.endTime!.addingTimeInterval(86400))! >= newMeditation.endTime! {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            newMeditation.currentStreak = currentStreak
            let lastBestStreak = last?.bestStreak ?? 0
            if (lastBestStreak < currentStreak) {
                newMeditation.bestStreak = currentStreak
            } else {
                newMeditation.bestStreak = lastBestStreak
            }
            print("new min: ", newMeditation.minutes)
            print("new bestStreak: ", newMeditation.bestStreak)
            print("new currentStreak: ", newMeditation.currentStreak)
            newMeditation.totalMinutes = newMeditation.minutes + last!.totalMinutes
            print("last end time", last?.endTime ?? "undefined")
        }
        do {
            try viewContext.save()
            print("meditation saved!")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimerView(viewRouter: ViewRouter())
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


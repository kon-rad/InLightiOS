//
//  TimerView.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI

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
    
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil
    @State var startTime: Date? = nil
    @State var initialTime: String? = nil
    
    var body: some View {
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
                            if self.timerIsPaused {
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
                            Text(self.timerIsPaused ? "start" : "stop")
                        }
                    }.buttonStyle(StartButtonStyle())
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
    func renderTime() -> String {
        if self.timerIsPaused {
            return "\(self.time):00"
        } else {
            return "\(self.minutes < 10 ? "0\(self.minutes)" : String(self.minutes)):\(self.seconds < 10 ? "0\(self.seconds)" : String(self.seconds))"
        }
    }
    func startTimer() {
        if !self.timerIsPaused {
            self.stopTimer()
            return
        }
        self.resetTimer()
        self.timerIsPaused = false
        self.minutes = Int(self.time)!
        self.initialTime = self.time
        self.startTime = Date()
        self.attemptSound()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
            if seconds == 0 && self.minutes == 0 || seconds == 58 {
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
        self.timerIsPaused = true
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


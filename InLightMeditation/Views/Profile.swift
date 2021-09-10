//
//  Profile.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/6/21.
//

import SwiftUI

struct Profile: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Meditation.entity(), sortDescriptors: [])
    
    var meditations: FetchedResults<Meditation>
    
    @State var currentStreak: Int16?
    @State var bestStreak: Int16?
    @State var totalMinutes: Int16?
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("user_icon")
                .resizable()
                .frame(width: 70, height: 70.0)
                .padding(.top, 50)
            HStack {
                Spacer()
                VStack {
                    Text("\(String(self.currentStreak ?? 0))")
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
            List {
                ForEach(meditations) { meditation in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Duration: \(meditation.minutes) minutes")
                                .font(.subheadline)
                            Text(verbatim: self.renderTime(date: meditation.startTime!))
                                .font(.subheadline)
//                            Text("End time: \(meditation.endTime)")
//                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    .frame(height: 60)
                }
                .padding(.top, 10)
            }
                .listStyle(PlainListStyle())
            Spacer()
        }.onAppear {
            let last = meditations.last
            self.currentStreak = last?.currentStreak
            self.bestStreak = last?.bestStreak
            self.totalMinutes = last?.totalMinutes
        }
    }
    func renderTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dateString = formatter.string(from: date)
        return "Start time: \(dateString)"
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

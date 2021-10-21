//
//  CurrentStreak.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/11/21.
//

import SwiftUI

struct CurrentStreak: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Meditation.entity(), sortDescriptors: [])
    
    var meditations: FetchedResults<Meditation>
    @State var currentStreak: Int16 = 44
    
    init() {
        let last = meditations.last
        _currentStreak = State(initialValue: last?.currentStreak ?? 0)
    }
    
    var body: some View {
        VStack {
            ForEach (0 ..< Int(self.currentStreak), id: \.self) { index in
                if (index == 0 || index % 7 == 0) {
                    if (self.currentStreak < (index + 7)) {
                        StreakWeek(start: Int(index), end: Int(self.currentStreak))
                    } else {
                        StreakWeek(start: Int(index), end: Int(index + 7))
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .frame(width: 260)
        .onAppear() {
            let last = meditations.last
            self.currentStreak = last?.currentStreak ?? 0
        }
    }
}

struct CurrentStreak_Previews: PreviewProvider {
    static var previews: some View {
        CurrentStreak()
    }
}

struct StreakWeek: View {
    var start: Int
    var end: Int
    
    var body: some View {
        HStack {
            ForEach (self.start ..< self.end) { _ in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.yellow)
                    .frame(width: 30, height: 30, alignment: .leading)
            }
        }
        .onAppear() {
            print("start: \(self.start) - \(self.end)")
        }
        .frame(width: 260, alignment: .leading)
    }
}

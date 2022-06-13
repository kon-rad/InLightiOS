//
//  CurrentStreak.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 9/11/21.
//

import SwiftUI

struct CurrentStreak: View {
    
    var currentStreak: Int = 0
    @State private var purpleSquares: Int = 0
    @State private var yellowSquares: Int = 0

    
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
            self.purpleSquares = Int((Double(self.currentStreak) / 30.0).rounded(.down))
            self.yellowSquares = self.currentStreak <= 30 ? self.currentStreak : self.currentStreak % 30
        }
    }
}

struct CurrentStreak_Previews: PreviewProvider {
    static var previews: some View {
        CurrentStreak(currentStreak: 35)
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
//            print("start: \(self.start) - \(self.end)")
        }
        .frame(width: 260, alignment: .leading)
    }
}

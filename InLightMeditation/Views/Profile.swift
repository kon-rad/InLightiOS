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
    
    
    var body: some View {
        
        VStack {
            Spacer()
            Image("user_icon")
                .resizable()
                .frame(width: 90, height: 90.0)
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

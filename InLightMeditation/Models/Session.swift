//
//  Session.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 1/9/22.
//

import Foundation
import FirebaseDatabase

struct Session: Identifiable, Hashable {
    
    let ref: DatabaseReference?
    let startTime: String
    let endTime: String
    let duration: Int
    let note: String
    let stars: Int
    let id = UUID()
    
    init(startTime: String, endTime: String, duration: Int, note: String, stars: Int) {
        self.ref = nil
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.note = note
        self.stars = stars
    }
    
    func toAnyObject() -> Any {
        return [
            "startTime": startTime,
            "endTime": endTime,
            "duration": duration,
            "note": note,
            "stars": stars,
        ]
    }
}

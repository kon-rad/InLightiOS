//
//  Session.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 1/9/22.
//

import Foundation
import FirebaseDatabase

struct Session: Identifiable {
    
    let ref: DatabaseReference?
    let startTime: String
    let endTime: String
    let id: String?
    let duration: Int
    let note: String
    let emoji: String
    
    init(startTime: String, endTime: String, duration: Int, note: String, emoji: String) {
        self.ref = nil
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.note = note
        self.emoji = emoji
        self.id = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "startTime": startTime,
            "endTime": endTime,
            "duration": duration,
            "note": note,
            "emoji": emoji,
        ]
    }
}

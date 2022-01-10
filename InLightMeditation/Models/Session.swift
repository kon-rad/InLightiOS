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
//    let duration: String
//    let note: String
//    let minutes: Int16
//    let key: String
    
    init(startTime: String, endTime: String) {
        self.ref = nil
        self.startTime = startTime
        self.endTime = endTime
        self.id = nil
//        self.note = note
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let startTime = value["startTime"] as? String,
            let endTime = value["endTime"] as? String
            else {
                return nil
            }
        
        self.ref = snapshot.ref
//        self.key = snapshot.key
        self.startTime = startTime
        self.endTime = endTime
        self.id = snapshot.key
        
    }
    
    func toAnyObject() -> Any {
        return [
            "startTime": startTime,
            "endTime": endTime,
        ]
    }
}

//
//  User.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 1/9/22.
//

import Foundation
class User {
    
    var uid: String
    var email: String?
//    var displayName: String?
//    var bestStreak: Int16
//    var currentStreak: Int16
//    var totalMinutes: Int16
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
//        self.displayName = displayName
    }
}

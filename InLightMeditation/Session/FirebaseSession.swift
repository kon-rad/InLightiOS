//
//  FirebaseSession.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 1/9/22.
//

import SwiftUI
import Firebase
import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseSession: ObservableObject {
    
    //MARK: Properties
    @Published var session: User?
    @Published var isLoggedIn: Bool = false
    @Published var email: String = ""
    @Published var items: [Session] = []
    @Published var currentStreak: Int = 0
    @Published var lastSessionStart: String = ""
    @Published var bestStreak: Int = 0
    @Published var totalMinutes: Int = 0
    
    var ref: DatabaseReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
    
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
                self.isLoggedIn = true
                self.email = user.email ?? ""
                print("logged in --- session")
                self.ref = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
            } else {
                print("logged out --- session")
                self.clearMemory()
            }
        }
    }
    
    func getSessions() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref.observe(DataEventType.value) { (snapshot) in
            self.items = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                   
                   if let datavalue = snapshot.value as? [String:Any] {
                        let startTime = datavalue["startTime"] != nil ? datavalue["startTime"] as! String : ""
                        let endTime = datavalue["endTime"] != nil ? datavalue["endTime"] as! String : ""
                        let duration = datavalue["duration"] != nil ? datavalue["duration"] as! Int : 0
                        let note = datavalue["note"] != nil ? datavalue["note"] as! String : ""
                        let emoji = datavalue["emoji"] != nil ? datavalue["emoji"] as! String : ""

                       let session = Session(startTime: startTime, endTime: endTime, duration: duration, note: note, emoji: emoji)
                       self.items.insert(session, at: 0)
                   }
                
                }
            }
            if let datavalue = snapshot.value as? [String:Any] {
                self.currentStreak = datavalue["currentStreak"] != nil ? datavalue["currentStreak"] as! Int : 0
                self.lastSessionStart = datavalue["lastSessionStart"] != nil ? datavalue["lastSessionStart"] as! String : ""
                self.bestStreak = datavalue["bestStreak"] != nil ? datavalue["bestStreak"] as! Int : 0
                self.totalMinutes = datavalue["totalMinutes"] != nil ? datavalue["totalMinutes"] as! Int : 0
            }
        }
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        getSessions()
    }
    
    func signOut() {
        try! Auth.auth().signOut()
        clearMemory()
    }
    
    func clearMemory() {
        self.isLoggedIn = false
        self.session = nil
        self.items = []
        self.currentStreak = 0
        self.bestStreak = 0
        self.totalMinutes = 0
        self.email = ""
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        self.items = []
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        getSessions()
    }
    
    func uploadSession(
            startTime: String,
            endTime: String,
            currentStreak: Int,
            lastSessionStart: String,
            bestStreak: Int,
            totalMinutes: Int,
            duration: Int,
            note: String,
            emoji: String
    ) {
        // Generates number going up as time goes on, sets order of Sessions's by how old they are.
        let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        
        let postRef = ref.child(String(number))
        let sess = Session(startTime: startTime, endTime: endTime, duration: duration, note: note, emoji: emoji)
        postRef.setValue(sess.toAnyObject())
        ref.child("currentStreak").setValue(currentStreak)
        ref.child("lastSessionStart").setValue(lastSessionStart)
        ref.child("bestStreak").setValue(bestStreak)
        ref.child("totalMinutes").setValue(totalMinutes)
    }
    
    func updateSession(key: String, todo: String, isComplete: String) {
//        let update = ["todo": todo, "isComplete": isComplete]
//        let childUpdate = ["\(key)": update]
//        ref.updateChildValues(childUpdate)
    }
}


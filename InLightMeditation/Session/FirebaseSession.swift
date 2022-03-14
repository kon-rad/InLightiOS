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
    @Published var items: [Session] = []
    @Published var currentStreak: Int = 0
    @Published var lastSessionStart: String = ""
    
    var ref: DatabaseReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
    
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
                self.isLoggedIn = true
                print("logged in --- session")
                self.ref = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
            } else {
                print("logged out --- session")
                self.isLoggedIn = false
                self.session = nil
            }
        }
    }
    
    func getSessions() {
        print("getSession is called")
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print(userID)
        ref.observe(DataEventType.value) { (snapshot) in
            self.items = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let session = Session(snapshot: snapshot) {
                    self.items.append(session)
                    print("session found: ", session)
                }
            }
            if let datavalue = snapshot.value as? [String:Any] {
                self.currentStreak = datavalue["currentStreak"] as! Int
                self.lastSessionStart = datavalue["lastSessionStart"] as! String
            }
        }
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        print("pre login")
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        print("post login")
        getSessions()
    }
    
    func signOut() {
        print("signOut is called")
        try! Auth.auth().signOut()
        self.isLoggedIn = false
        self.session = nil
        self.items = []
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        print("pre signup")
        self.items = []
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        print("post signup")
        getSessions()
    }
    
    func uploadSession(startTime: String, endTime: String, currentStreak: Int, lastSessionStart: String) {
        print("upload session called: ", startTime, endTime)
        print("uploadSession self.items: ", self.items)
        // Generates number going up as time goes on, sets order of Sessions's by how old they are.
        let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        
        let postRef = ref.child(String(number))
        let sess = Session(startTime: startTime, endTime: endTime)
        postRef.setValue(sess.toAnyObject())
        ref.child("currentStreak").setValue(currentStreak)
        ref.child("lastSessionStart").setValue(lastSessionStart)
        print("new session created: ", sess, currentStreak, lastSessionStart)
    }
    
    func updateSession(key: String, todo: String, isComplete: String) {
//        let update = ["todo": todo, "isComplete": isComplete]
//        let childUpdate = ["\(key)": update]
//        ref.updateChildValues(childUpdate)
    }
}


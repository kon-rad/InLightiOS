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
    @Published var defaultTime: String = "10"
    @Published var avatar: UIImage?
    @Published var hasAvatar: Bool = false
    @Published var username: String?
    @Published var motivation: String?
    
    let storage = Storage.storage()
    
    var ref: DatabaseReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
    
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
                self.isLoggedIn = true
                self.email = user.email ?? ""
                print("logged in --- session")
                self.ref = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
                self.getSessions()
            } else {
                print("logged out --- session")
                self.clearMemory()
            }
        }
    }
    
    func getSessions() {
        print("getSessions is called")
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print("getSessions is called with userID: ", userId)
        
        getAvatar(userId: userId)
        
        let sessionsRef: DatabaseReference = Database.database().reference(withPath: "\(userId)/sessions")
        sessionsRef.observe(DataEventType.value) { (snapshot) in
            self.items = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                   
                   if let datavalue = snapshot.value as? [String:Any] {
                        let startTime = datavalue["startTime"] != nil ? datavalue["startTime"] as! String : ""
                        let endTime = datavalue["endTime"] != nil ? datavalue["endTime"] as! String : ""
                        let duration = datavalue["duration"] != nil ? datavalue["duration"] as! Int : 0
                        let note = datavalue["note"] != nil ? datavalue["note"] as! String : ""
                        let stars = datavalue["stars"] != nil ? datavalue["stars"] as! Int : 0

                       let session = Session(startTime: startTime, endTime: endTime, duration: duration, note: note, stars: stars)
                       self.items.insert(session, at: 0)
                   }
                }
            }
        }
        
        ref.observe(DataEventType.value) { (snapshot) in
            if let datavalue = snapshot.value as? [String:Any] {
                self.currentStreak = datavalue["currentStreak"] != nil ? datavalue["currentStreak"] as! Int : 0
                self.lastSessionStart = datavalue["lastSessionStart"] != nil ? datavalue["lastSessionStart"] as! String : ""
                self.bestStreak = datavalue["bestStreak"] != nil ? datavalue["bestStreak"] as! Int : 0
                self.totalMinutes = datavalue["totalMinutes"] != nil ? datavalue["totalMinutes"] as! Int : 0
                self.defaultTime = datavalue["defaultTime"] != nil ? datavalue["defaultTime"] as! String : "10"
                if (datavalue["username"] != nil) {
                    self.username = datavalue["username"] as! String
                }
                if (datavalue["motivation"] != nil) {
                    self.motivation = datavalue["motivation"] as! String
                }
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
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        
        deleteAvatar()
        
        user?.delete { error in
          if let error = error {
              print("error while deleting user: ", error)
          } else {
              self.clearMemory()
          }
        }
    }
    
    func deleteAvatar() {
        let user = Auth.auth().currentUser
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let avatarRef = storage.reference().child("avatars/\(userId)")
        
        // Delete the file
        avatarRef.delete { error in
          if let error = error {
            // Uh-oh, an error occurred!
              print("error while deleting user avatar: ", error);
          } else {
            // File deleted successfully
              print("delete user avatar: ", userId);
              self.avatar = nil
              self.hasAvatar = false
          }
        }
    }
    
    func clearMemory() {
        self.isLoggedIn = false
        self.session = nil
        self.items = []
        self.currentStreak = 0
        self.bestStreak = 0
        self.totalMinutes = 0
        self.email = ""
        self.defaultTime = "10"
        self.avatar = nil
        self.hasAvatar = false
        self.motivation = ""
        self.username = ""
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
            stars: Int
    ) {
        // Generates number going up as time goes on, sets order of Sessions's by how old they are.
        let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        
        let postRef = ref.child("sessions").child(String(number))
        let sess = Session(startTime: startTime, endTime: endTime, duration: duration, note: note, stars: stars)
        postRef.setValue(sess.toAnyObject())
        ref.child("currentStreak").setValue(currentStreak)
        ref.child("lastSessionStart").setValue(lastSessionStart)
        ref.child("bestStreak").setValue(bestStreak)
        ref.child("totalMinutes").setValue(totalMinutes)
    }
    
    func getAvatar(userId: String) {
        // Create a reference
        let avatarRef = storage.reference().child("avatars/\(userId)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        avatarRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
              print("error downloading avatar", error)
          } else {
              self.avatar = UIImage(data: data!)!
              self.hasAvatar = true
          }
        }
    }
    
    func updateProfile(username: String, motivation: String) {
        ref.child("username").setValue(username)
        ref.child("motivation").setValue(motivation)
    }
    
    func updateDefaultTime(time: String) {
        ref.child("defaultTime").setValue(time)
    }
    
    func updateSession(key: String, todo: String, isComplete: String) {
//        let update = ["todo": todo, "isComplete": isComplete]
//        let childUpdate = ["\(key)": update]
//        ref.updateChildValues(childUpdate)
    }
}


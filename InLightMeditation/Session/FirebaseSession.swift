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
    
    var ref: DatabaseReference = Database.database().reference(withPath: "\(String(describing: Auth.auth().currentUser?.uid ?? "Error"))")
    
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
                self.isLoggedIn = true
                print("logged in --- session")
                self.getSessions()
            } else {
                print("logged out --- session")
                self.isLoggedIn = false
                self.session = nil
            }
        }
    }
    
    func getSessions() {
        ref.observe(DataEventType.value) { (snapshot) in
            self.items = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let session = Session(snapshot: snapshot) {
                    self.items.append(session)
                    print("session found: ", session)
                }
            }
        }
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        print("pre login")
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        print("post login")
    }
    
    func signOut() {
        try! Auth.auth().signOut()
        self.isLoggedIn = false
        self.session = nil
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        print("pre signup")
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        print("post login")
    }
    
    func uploadSession(startTime: String, endTime: String) {
        print("upload session called: ", startTime, endTime)
        //Generates number going up as time goes on, sets order of TODO's by how old they are.
        let number = Int(Date.timeIntervalSinceReferenceDate * 1000)
        
        let postRef = ref.child(String(number))
        let sess = Session(startTime: startTime, endTime: endTime)
        postRef.setValue(sess.toAnyObject())
        print("new session created: ", sess)
    }
    
    func updateSession(key: String, todo: String, isComplete: String) {
//        let update = ["todo": todo, "isComplete": isComplete]
//        let childUpdate = ["\(key)": update]
//        ref.updateChildValues(childUpdate)
    }
}


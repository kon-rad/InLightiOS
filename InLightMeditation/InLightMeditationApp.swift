//
//  InLightMeditationApp.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI
import CoreData
import Firebase
import FirebaseAuth
import FirebaseFirestore

@main
struct InLightMeditationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    @StateObject var session = FirebaseSession()
    
    init() {
       FirebaseApp.configure()
    }
    
    func handlePasswordlessSignIn(_ withURL: URL) {
        print("sign in ")
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(session)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("application function")
        return userActivity.webpageURL.flatMap(handlePasswordlessSignIn)!
    }
    
    func handlePasswordlessSignIn(withUrl: URL) -> Bool {
        let link = withUrl.absoluteString
        print("handlePasswordlessSignIn")
        
        if Auth.auth().isSignIn(withEmailLink: link) {
            
            guard let email = UserDefaults.standard.value(forKey: "konradmgnat@gmail.com") else { return false }
            
            Auth.auth().signIn(withEmail: email as! String, link: link) { (result, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                guard let result = result else { return }
                
                let uid = result.user.uid
                
                let data = [
                    "uid": uid,
                    "email": email
//                    "timeStamp": FieldValue.serverTimeStamp()
                ] as [String : Any]
                
                Firestore.firestore().collection("users").document(uid).setData(data, completion: { (err) in
                    if let err = err {
                        print(err.localizedDescription)
                        return
                    }
                    print("signed in!!!!")
//                    UIAlertService.showAlert
                })
            }
            print("signed in!!!! - return true")
            return true;
        }
        return false
    }
}

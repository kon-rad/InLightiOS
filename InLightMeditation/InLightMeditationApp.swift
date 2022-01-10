//
//  InLightMeditationApp.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI
import CoreData
import Firebase

@main
struct InLightMeditationApp: App {
    let persistenceController = PersistenceController.shared
    
    //Firebase
    
    init() {
       FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SpashScreenView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  InLightMeditationApp.swift
//  InLightMeditation
//
//  Created by Konrad Gnat on 8/28/21.
//

import SwiftUI
import CoreData

@main
struct InLightMeditationApp: App {
    let persistenceController = PersistenceController.shared
    
    
    var body: some Scene {
        WindowGroup {
            SpashScreenView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

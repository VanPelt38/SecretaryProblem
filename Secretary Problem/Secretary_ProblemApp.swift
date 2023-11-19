//
//  Secretary_ProblemApp.swift
//  Secretary Problem
//
//  Created by Jake Gordon on 19/11/2023.
//

import SwiftUI

@main
struct Secretary_ProblemApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

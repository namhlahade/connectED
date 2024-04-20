//
//  connectEdApp.swift
//  connectEd
//
//  Created by Neel Runton on 3/24/24.
//

import SwiftUI
import SwiftData

@main
struct connectEdApp: App {
    
    var body: some Scene {
        let authenticationService = FakeAuthenticationService()
        var sharedModelContainer: ModelContainer = {
            let schema = Schema([
                User.self,
                Email.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        WindowGroup {
            if (authenticationService.maybeLoginSavedUser(modelContext: sharedModelContainer.mainContext)){
                TabContainer(tutors: Tutor.previewData)
            } else{
                LoginScreen()
                    .onAppear { authenticationService.maybeLoginSavedUser(modelContext: sharedModelContainer.mainContext) }
            
            }
        }
        .modelContainer(sharedModelContainer)
        .environment(authenticationService)
    }
}

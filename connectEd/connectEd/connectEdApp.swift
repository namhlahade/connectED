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
        WindowGroup {
            TabContainer(tutors: Tutor.previewData)
        }
        //.modelContainer(for: [Tutor.self])
    }
}

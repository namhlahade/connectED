//
//  ContentView.swift
//  connectEd
//
//  Created by Neel Runton on 3/24/24.
//

import SwiftUI

struct TabContainer: View {
    let tutors: [Tutor]
    var body: some View {
        TabView {
            NavigationStack {
                Search()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            NavigationStack {
                Favorites()
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            NavigationStack {
                Profile(user: Tutor(name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false, availability_days: [], availability_times: []))
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            NavigationStack {
                AITutor()
            }
            .tabItem {
                Label("Cipher", systemImage: "brain.head.profile")
            }
        }
        
    }
}

#Preview {
    TabContainer(tutors: Tutor.previewData)
}

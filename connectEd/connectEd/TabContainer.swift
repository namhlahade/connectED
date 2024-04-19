//
//  ContentView.swift
//  connectEd
//
//  Created by Neel Runton on 3/24/24.
//

import SwiftUI

struct TabContainer: View {
    @State var tutors: [Tutor]
    var body: some View {
        TabView {
            NavigationStack {
                Search(tutors: tutors)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            NavigationStack {
                Favorites(tutors: tutors)
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            NavigationStack {
                AITutor()
            }
            .tabItem {
                Label("Cipher", systemImage: "brain.head.profile")
            }
            NavigationStack {
                Profile(user: Tutor(name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false, availability_days: [], availability_times: []))
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        
    }
}

#Preview {
    TabContainer(tutors: Tutor.previewData)
}

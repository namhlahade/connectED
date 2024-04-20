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
                    .navigationTitle("Your Saviors")
            }
            .tabItem {
                Label("Browse", systemImage: "house.fill")
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
                ProfileView(email: "nlahade@gmail.com")
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

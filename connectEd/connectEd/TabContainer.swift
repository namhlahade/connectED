//
//  ContentView.swift
//  connectEd
//
//  Created by Neel Runton on 3/24/24.
//

import SwiftUI

struct TabContainer: View {
    @State private var isLoggedOut = false
    @State var tutors: [Tutor]
    var body: some View {
        if isLoggedOut {
            LoginScreen()
        } else{
            
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
                    UserProfile(user: Tutor(name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, reviews: [], isFavorite: false, availability: []), loggedOut: $isLoggedOut)
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            }
        }
        
    }
}

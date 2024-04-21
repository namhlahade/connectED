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
    @Binding var email: String
    var body: some View {
        if isLoggedOut {
            LoginScreen()
        } else{
            TabView {
                NavigationStack {
                    ParentSearch(user: Tutor.previewData[0])
                }
                .tabItem {
                    Label("Browse", systemImage: "house.fill")
                }
                NavigationStack {
                    ParentFavorites(user: Tutor.previewData[0])
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
                    ProfileView(email: email, isLoggedOut: $isLoggedOut)
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            }
        }
    }
}

struct TabContainer_Previews: PreviewProvider {
    @State static var email = ""
    static var previews: some View {
        TabContainer(tutors: Tutor.previewData, email: $email)
    }
}

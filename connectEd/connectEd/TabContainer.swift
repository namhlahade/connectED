//
//  ContentView.swift
//  connectEd
//
//  Created by Neel Runton on 3/24/24.
//

import SwiftUI

struct ParentTabContainer: View {
    let getTutorLoader = GetTutorLoader()
    @Binding var email: String
    @Binding var loggedIn: Bool
    
    var body: some View {
        VStack {
            switch getTutorLoader.state {
            case .idle: Color.clear
            case .loading: ProgressView()
            case .failed(let error): Text("Error \(error.localizedDescription)")
            case .success(let allTutorInfo):
                TabContainer(loggedIn: $loggedIn, email: $email, tutors: allTutorInfo.getTutors())
            }
        }
        .task { await getTutorLoader.getAllTutorInfo() }
    }
}


struct TabContainer: View {
    @Binding var loggedIn: Bool
    @Binding var email: String
    @State var tutors: [Tutor]
    
    var body: some View {
            TabView {
                NavigationStack {
                    ParentSearch(user: tutors.filter({ $0.email == email }).first!)
                }
                .tabItem {
                    Label("Browse", systemImage: "house.fill")
                }
                NavigationStack {
                    ParentFavorites(user: tutors.filter({$0.email == email}).first!)
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
                    ProfileView(email: email, loggedIn: $loggedIn)
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            }
    }
}

struct TabContainer_Previews: PreviewProvider {
    @State static var email = "nrunton@gmail.com"
    @State static var loggedIn = true
    static var previews: some View {
        TabContainer(loggedIn: $loggedIn, email: $email, tutors: Tutor.previewData)
    }
}

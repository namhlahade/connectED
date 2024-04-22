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
    
    var body: some View {
        VStack {
            switch getTutorLoader.state {
            case .idle: Color.clear
            case .loading: ProgressView()
            case .failed(let error): Text("Error \(error.localizedDescription)")
            case .success(let allTutorInfo):
                TabContainer(email: $email, tutors: allTutorInfo.getTutors())
            }
        }
        .task { await getTutorLoader.getAllTutorInfo() }
    }
}


struct TabContainer: View {
    @State private var isLoggedOut = false
    @Binding var email: String
    @State var tutors: [Tutor]
    
    var body: some View {
        if isLoggedOut {
            LoginScreen()
            //isLoggedOut = false
        } else{
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
    @State static var email = "nrunton@gmail.com"
    static var previews: some View {
        TabContainer(email: $email, tutors: Tutor.previewData)
    }
}

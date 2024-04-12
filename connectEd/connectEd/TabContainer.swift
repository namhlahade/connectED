//
//  ContentView.swift
//  connectEd
//
//  Created by Neel Runton on 3/24/24.
//

import SwiftUI

struct TabContainer: View {
    var body: some View {
        TabView {
            NavigationStack {
                Browse()
            }
            .tabItem {
                Label("Browse", systemImage: "house.fill")
            }
            NavigationStack {
                Search()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            NavigationStack {
                //Favorites()
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            NavigationStack {
                Profile(user: Tutor(name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false))
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        
    }
}

#Preview {
    TabContainer()
}

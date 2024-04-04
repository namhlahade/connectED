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
                Favorites()
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            NavigationStack {
                Profile(profileUrl: URL(string: "https://education-jrp.s3.amazonaws.com/MovieImages/EverythingEverywhereAllAtOnce.jpg"), rating: 3.6, name: "Neel Runton", email: "ndr19@duke.edu", courses: ["ECE110", "ECE230", "ECE280", "ECE270", "ECE532", "ECE539", "ECE575", "ECE572", "ECE350", "ECE331"], price: 23.00)
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

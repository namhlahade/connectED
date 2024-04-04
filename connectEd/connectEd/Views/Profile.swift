//
//  Profile.swift
//  connectEd
//
//  Created by Neel Runton on 4/1/24.
//

import SwiftUI

struct Profile: View {
    
    var profileUrl: URL?
    var rating: Double
    @State var name: String
    @State var email: String
    var courses: [String]
    var price: Double
    
    @State private var isPresentingEditForm: Bool = false
    
    var body: some View {
        
        ScrollView {
            
            AsyncImage(url: profileUrl, content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }, placeholder: {
                if profileUrl != nil {
                    ProgressView()
                } else {
                    Image(systemName: "person.circle")
                }
            })
            .frame(maxWidth: 250, maxHeight: 250)
            .padding()
            
            HStack (alignment: .center) {
                Text("My rating:")
                Text(String(format: "%.1f/5", rating)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            
            VStack (alignment: .leading) {
                
                ProfileSection(title: "Account Information", sectionLabels: ["Name", "Email"], sectionData: [name, email])
                
                ProfileSection(title: "Tutoring Information", sectionLabels: ["Courses", "Price per hour"], sectionData: [courses.sorted().joined(separator: ", "), String(format: "$%.2f", price)])
                
                
                Text("My Reviews").font(.title2)
                Spacer()
                // TODO add list of reviews here when Review datastructure is available
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isPresentingEditForm.toggle()
                }
            }
        }
        .sheet(isPresented: $isPresentingEditForm) {
            NavigationStack {
                ProfileForm(name: $name, email: $email) // TODO get data working on this. look at MovieTracker project MovieDetail.swift and MovieForm.swift for help
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") { isPresentingEditForm.toggle() }
                            
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                //Movie.update(movie, from: editMovieFormData)
                                isPresentingEditForm.toggle()
                            }
                        }
                    }
            }
        }
    }
}

struct ProfileSection: View {
    
    var title: String
    var sectionLabels: [String]
    var sectionData: [String]
    
    var body: some View {
        Text(title).font(.title2)
        Spacer()
        
        ForEach(sectionLabels.indices) { i in
            Text(sectionLabels[i]).fontWeight(.bold)
            Text(sectionData[i])
        }
        
        Spacer()
        Spacer()
    }
}


#Preview {
    NavigationStack {
        Profile(profileUrl: URL(string: "https://education-jrp.s3.amazonaws.com/MovieImages/EverythingEverywhereAllAtOnce.jpg"), rating: 3.6, name: "Neel Runton", email: "ndr19@duke.edu", courses: ["ECE 110", "ECE 230", "ECE280", "ECE 270", "ECE 532", "ECE 539", "ECE 575", "ECE 572", "ECE 350", "ECE 331"], price: 23.00)
    }
}

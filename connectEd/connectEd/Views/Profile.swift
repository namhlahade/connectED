//
//  Profile.swift
//  connectEd
//
//  Created by Neel Runton on 4/1/24.
//

import SwiftUI

struct Profile: View {
    
    @State var user: Tutor
    
    @State private var isPresentingEditForm: Bool = false
    
    var body: some View {
        
        ScrollView {
            
            AsyncImage(url: user.image, content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }, placeholder: {
                if user.image != nil {
                    ProgressView()
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            })
            .frame(maxWidth: 200, maxHeight: 200)
            .padding()
            
            HStack (alignment: .center) {
                Text("My rating:")
                Text(user.rating == nil ? "--/5" : String(format: "%.1f/5", user.rating!)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            
            VStack (alignment: .leading) {
                
                ProfileSection(title: "Account Information", sectionLabels: ["Name", "Email"], sectionData: [user.name, user.email])
                
                Spacer()
                Spacer()
                
                ProfileSection(title: "Tutoring Information", sectionLabels: ["Courses", "Price per hour"], sectionData: [(user.courses ?? ["None"]).sorted().joined(separator: ", "), user.price == nil ? "$--" : String(format: "$%.2f", user.price!)])
                
                Spacer()
                Spacer()
                
                
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
                ProfileForm(name: $user.name, email: $user.email) // TODO get data working on this. look at MovieTracker project MovieDetail.swift and MovieForm.swift for help
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
        VStack (alignment: .leading) {
            
            Text(title).font(.title2)
            
            Spacer()
            
            ForEach(sectionLabels.indices) { i in
                Text(sectionLabels[i]).font(.title3).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(sectionData[i])
                Spacer()
            }
            
        }
    }
}


#Preview {
    NavigationStack {
        Profile(user: Tutor(name: "Neel Runton", email: "ndr19@duke.edu", courses: ["ECE110", "ECE230", "ECE280", "ECE270", "ECE532", "ECE539", "ECE575", "ECE572", "ECE350", "ECE331"], image: URL(string: "https://education-jrp.s3.amazonaws.com/MovieImages/EverythingEverywhereAllAtOnce.jpg"), status: .online, rating: 3.61, price: 23.99))
    }
}

//
//  TutorProfile.swift
//  connectEd
//
//  Created by Nicholas Steinly on 4/18/24.
//

import SwiftUI


struct TutorProfile: View {
    
    @Bindable var tutor: Tutor
    
    var body: some View {
        
        Form {
            
            // TODO: change this to a SwiftUI saved image
            VStack (alignment: .center) {
                AsyncImage(url: URL(string: tutor.image ?? ""), content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }, placeholder: {
                    if tutor.image != nil {
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
                    Text("Rating:")
                    Text(String(format: "%.1f/5", tutor.rating)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            
            
            Section(header: Text("Actions")) {
                NavigationLink {
                    TutorBookingScreen(tutor: tutor)
                } label: {
                    Text("Schedule a tutoring session")
                }
                
                NavigationLink {
                    ReviewForm(tutor: tutor)
                } label: {
                    Text("Leave a review")
                }
            }
            
            
            
            ProfileSection(title: "Account Information", sectionLabels: ["Email", "About"], sectionData: [tutor.email, tutor.bio ?? "No bio provided"])
            
            
            ProfileSection(title: "Tutoring Information", sectionLabels: ["Courses", "Availability", "Price per hour"], sectionData: [tutor.courses.count == 0 ? "No courses provided" : getCourselist(courses: tutor.courses), tutor.availability.count == 0 ? "No availability provided" : printAvailability(availability: tutor.availability), tutor.price == nil ? "$0.00" : String(format: "$%.2f", tutor.price!)])
            
            
            Section(header: Text("Reviews")) {
                if (tutor.reviews.count == 0) {
                    Text("No reviews currently")
                }
                else {
                    List(tutor.reviews) { review in
                        // TODO: do review row
                        ReviewRow(review: review)
                    }
                }
            }
            
            
        }
        .navigationTitle(tutor.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    tutor.isFavorite.toggle()
                } label: {
                    Text(tutor.isFavorite ? "Unfavorite" : "Favorite")
                    Image(systemName: tutor.isFavorite ? "star.fill" : "star")
                }
            }
        }
        Spacer()
    }
    
}


#Preview {
    NavigationStack {
        TutorProfile(tutor: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, reviews: [], isFavorite: false, availability: []))
    }
}

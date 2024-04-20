//
//  TutorProfile.swift
//  connectEd
//
//  Created by Nicholas Steinly on 4/18/24.
//

import SwiftUI
import PhotosUI


struct TutorProfile: View {
    
    @Bindable var tutor: Tutor
    
    var body: some View {
        
        Form {
            
            VStack (alignment: .center) {
                if (tutor.image == Data() || tutor.image == nil) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .padding()
                    
                }
                else {
                    Image(uiImage: UIImage(data: tutor.image!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .padding()
                }
                
                
                HStack (alignment: .center) {
                    Text("Rating:")
                    Text(tutor.rating == 0 ? "--/5.0" : String(format: "%.1f/5.0", tutor.rating)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
            
            
            ProfileSection(title: "Tutoring Information", sectionLabels: ["Courses", "Availability", "Price per hour"], sectionData: [tutor.courses.count == 0 ? "No courses provided" : getCourselist(courses: tutor.courses), tutor.availability.count == 0 ? "No availability provided" : printAvailability(availability: tutor.availability), String(format: "$%.2f", tutor.price)])
            
            
            Section(header: Text("Reviews")) {
                if (tutor.reviews.count == 0) {
                    Text("No reviews currently")
                }
                else {
                    List(tutor.reviews) { review in
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
        TutorProfile(tutor: Tutor.previewData[0])
    }
}

//
//  TutorProfile.swift
//  connectEd
//
//  Created by Nicholas Steinly on 4/18/24.
//

import SwiftUI
import PhotosUI




struct TutorProfile: View {
    
    @State var user: Tutor
    @Bindable var tutor: Tutor
    
    let deleteFavoritesLoader = DeleteFavoriteLoader()
    let addFavoritesLoader = AddFavoriteLoader()
    
    
    var body: some View {
        
        Form {
            
            VStack (alignment: .center) {
                if tutor.image != "" {
                    Image(uiImage: UIImage(data: Data())!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .padding()
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .padding()
                }
                
                HStack (alignment: .center) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(maxWidth: 15, maxHeight: 15)
                        .foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    Text(tutor.status == .online ? "Available" : "Unavailable")
                    
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
                    if (user.favorites.contains(tutor.email)) {
                        Task {
                            await deleteFavoritesLoader.deleteFavoriteInfo(favoriteInput: FavoriteInputStruct(userEmail: user.email, tutorEmail: tutor.email))
                        }
                        user.favorites.remove(at: user.favorites.firstIndex(of: tutor.email)!)
                    }
                    else {
                        user.favorites.append(tutor.email)
                        Task {
                            await addFavoritesLoader.addToFavorites(favoriteInput: FavoriteInputStruct(userEmail: user.email, tutorEmail: tutor.email))
                        }
                    }
                } label: {
                    Text(user.favorites.contains(tutor.email) ? "Unfavorite" : "Favorite")
                    Image(systemName: user.favorites.contains(tutor.email) ? "star.fill" : "star")
                }
            }
        }
        Spacer()
    }
    
}


#Preview {
    NavigationStack {
        TutorProfile(user: Tutor.previewData[0], tutor: Tutor.previewData[1])
    }
}

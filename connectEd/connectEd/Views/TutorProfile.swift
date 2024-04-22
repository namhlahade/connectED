//
//  TutorProfile.swift
//  connectEd
//
//  Created by Nicholas Steinly on 4/18/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage



struct TutorProfile: View {
    
    @State var user: Tutor
    @Bindable var tutor: Tutor
    
    let deleteFavoritesLoader = DeleteFavoriteLoader()
    let addFavoritesLoader = AddFavoriteLoader()
    
    @State var profilePic: UIImage? = nil
    
    
    var body: some View {
        
        Form {
            
            VStack (alignment: .center) {
                
                if tutor.image != "" {
                    if profilePic == nil {
                        ProgressView()
                    }
                    else {
                        Image(uiImage: profilePic!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 200, maxHeight: 200)
                            .padding()
                    }
                }
                else {
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
                    RatingView(rating: $tutor.rating).font(.title)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .onAppear {
                if tutor.image != "" {
                    getPhoto(path: tutor.image)
                    print("Getting profile pic on Appear")
                }
            }
            
            
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
    
    func getPhoto(path: String) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    // what variable gets updated?
                    profilePic = image
                }
            }
            else {
                print(error)
            }
        }
    }
    
}


#Preview {
    NavigationStack {
        TutorProfile(user: Tutor.previewData[0], tutor: Tutor.previewData[1])
    }
}

//
//  Profile.swift
//  connectEd
//
//  Created by Neel Runton on 4/1/24.
//

import SwiftUI

struct ProfileView: View {
    let email: String
    @Environment(FakeAuthenticationService.self) var authenticationService
    let getTutorLoader = GetTutorLoader()
    
    @Binding var isLoggedOut: Bool
    var body: some View {
    VStack {
      switch getTutorLoader.state {
      case .idle: Color.clear
      case .loading: ProgressView()
      case .failed(let error): Text("Error \(error.localizedDescription)")
      case .success(let tutorInformation):
          if let tutor = tutorInformation.getTutors().filter({ $0.email == email }).first {
                     UserProfile(user: tutor, loggedOut: $isLoggedOut)
                 } else {
                     Text("No tutor found with email: \(email)")
                     
                     Button("Logout") {
                         authenticationService.logout()
                     }
                 }
      }
    }
    .task { await getTutorLoader.getAllTutorInfo() }
  }
}

struct UserProfile: View {
    
    @Bindable var user: Tutor
    let authenticationService = FakeAuthenticationService()
    @State private var isPresentingEditForm: Bool = false
    @State private var editTutorFormData: Tutor.FormData = Tutor.FormData()
    
    @Binding var loggedOut: Bool
    var body: some View {
        
        Form {
            
            VStack (alignment: .center) {
                if (user.image == Data() || user.image == nil) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .padding()
                    
                }
                else {
                    Image(uiImage: UIImage(data: user.image!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 200)
                        .padding()
                }
                
                HStack (alignment: .center) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(maxWidth: 15, maxHeight: 15)
                        .foregroundStyle(user.status == .online ? Color.green : Color.red)
                    Text(user.status == .online ? "Available" : "Unavailable")
                    
                }
                
                HStack (alignment: .center) {
                    Text("My rating:")
                    Text(user.rating == 0 ? "--/5.0" : String(format: "%.1f/5.0", user.rating)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            
            
            
            ProfileSection(title: "Account Information", sectionLabels: ["Name", "Email", "About me"], sectionData: [user.name, user.email, user.bio ?? "No bio entered"])
            
            
            ProfileSection(title: "Tutoring Information", sectionLabels: ["Courses", "Availability", "Price per hour"], sectionData: [getCourselist(courses: user.courses), printAvailability(availability: user.availability), String(format: "$%.2f", user.price)])
            
            
            Section(header: Text("My Reviews")) {
                if (user.reviews.count == 0) {
                    Text("You currently have no reviews")
                }
                else {
                    List(user.reviews) { review in
                        ReviewRow(review: review)
                    }
                }
            }
            
        }
        .navigationTitle("My Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Logout") {
                    authenticationService.logout()
                    loggedOut = true
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    editTutorFormData = user.dataForForm
                    isPresentingEditForm.toggle()
                }
            }
        }
        .sheet(isPresented: $isPresentingEditForm) {
            NavigationStack {
                ProfileForm(data: $editTutorFormData)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                isPresentingEditForm.toggle()
                            }
                            
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Edit Profile").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Logout").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                Tutor.update(user, from: editTutorFormData)
                                isPresentingEditForm.toggle()
                                // TODO: make API call to edit profile
                            }
                        }
                    }
            }
        }
    }
}

func getCourselist(courses: [Course]) -> String {
    if courses.count == 0 {
        return "No courses entered"
    }
    var courseList: String = ""
    for i in courses {
        courseList.append("\(i.subject.rawValue.uppercased()) \(i.code), ")
    }
    return String(courseList.prefix(courseList.count - 2))
}

func getCourseStrings(courses: [Course]) -> [String] {
    if courses.count == 0 {
        return []
    }
    var courseList: [String] = []
    for i in courses {
        courseList.append("\(i.subject.rawValue.uppercased()) \(i.code)")
    }
    print(courseList)
    return courseList
}

func printAvailability(availability: [Availability]) -> String {
    if availability.count == 0 {
        return "No availability entered"
    }
    
    var ret: String = ""
    
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    
    for (index, _) in availability.enumerated() {
        ret.append("\(availability[index].day.rawValue.capitalized(with: nil)) \(formatter.string(from: availability[index].times[0])) - \(formatter.string(from: availability[index].times[1]))\n")
    }
    
    return String(ret.prefix(ret.count - 1))
}

struct ProfileSection: View {
    
    var title: String
    var sectionLabels: [String]
    var sectionData: [String]
    
    var body: some View {
        Section(header: Text(title)) {
            ForEach(sectionLabels.indices) { i in
                VStack(alignment: .leading) {
                    Text(sectionLabels[i]).font(.title3).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text(sectionData[i])
                }
            }
        }
    }
}


struct UserProfile_Previews: PreviewProvider {
    @State static var isLoggedOut = false
    static var previews: some View {
        NavigationStack {
            UserProfile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, price: 0, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], favorites: [], availability: []), loggedOut: $isLoggedOut)
        }
        
    }
}

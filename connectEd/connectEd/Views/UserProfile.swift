//
//  Profile.swift
//  connectEd
//
//  Created by Neel Runton on 4/1/24.
//

import SwiftUI
import Symbols
import FirebaseStorage

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
    
    let editProfileLoader = EditProfileLoader()
    @State var user: Tutor
    let authenticationService = FakeAuthenticationService()
    @State private var isPresentingEditForm: Bool = false
    @State private var editTutorFormData: Tutor.FormData = Tutor.FormData()
    
    @Binding var loggedOut: Bool
    var body: some View {
        
        Form {
            
            VStack (alignment: .center) {
                AsyncImage(url: URL(string: user.image), content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }, placeholder: {
                    if user.image != "" {
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
                Button(action: {
                    authenticationService.logout()
                    loggedOut = true
                }) {
                    Text("Log Out")
                    
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
                                uploadPhoto(imageToUpload: UIImage(data: user.imageData!)!) // Upload new profile picture to Firebase
                                Task {
                                    await editProfileLoader.editProfile(editProfileInput: EditTutorInput(tutorEmail: user.email, image: user.image, name: user.name, bio: user.bio ?? "", courses: getCourseStrings(courses: user.courses), price: user.price, availability: castAvailability(availability: user.availability)))
                                }
                            }
                        }
                    }
            }
        }
    }
}

func uploadPhoto(imageToUpload: UIImage) -> Void {
    print("Hello dude")
    let storageRef = Storage.storage().reference()
    let imageData_ = imageToUpload.jpegData(compressionQuality: 0.8)
    
    guard imageData_ != nil else {
        return
    }
    let path = "Images/\(UUID().uuidString).jpg"
    print(path)
    let fileRef = storageRef.child(path)
    let uploadTask = fileRef.putData(imageData_!, metadata: nil) {metadata, error in
        if error == nil && metadata != nil {
            // handle upload error
        }
    }
}

func getPhoto(path: String, completion: @escaping (UIImage?) -> Void) {
    let storageRef = Storage.storage().reference()
    let fileRef = storageRef.child(path)

    fileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if let error = error {
            print("Error downloading image: \(error)")
            completion(nil)
        } else if let data = data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            DispatchQueue.main.async {
                completion(nil)
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
    @State var cop: Int = 0
    
    static var previews: some View {
        NavigationStack {
         UserProfile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, price: 0, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], favorites: [], availability: []), loggedOut: $isLoggedOut)
         }
        
    }
}


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

    @Binding var loggedIn: Bool
    var body: some View {
        VStack {
            switch getTutorLoader.state {
            case .idle: Color.clear
            case .loading: ProgressView()
            case .failed(let error): Text("Error \(error.localizedDescription)")
            case .success(let tutorInformation):
                if let tutor = tutorInformation.getTutors().filter({ $0.email == email }).first {
                    UserProfile(user: tutor, loggedIn: $loggedIn)
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
    
    @Binding var loggedIn: Bool

    @State var profilePic: UIImage? = nil
    
    var body: some View {
        
        Form {
            
            VStack (alignment: .center) {
                if user.image != "" {
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
                        .foregroundStyle(user.status == .online ? Color.green : Color.red)
                    Text(user.status == .online ? "Available" : "Unavailable")
                    
                }
                
                HStack (alignment: .center) {
                    RatingView(rating: $user.rating).font(.title)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .onAppear {
                if user.image != "" {
                    getPhoto(path: user.image)
                    print("Getting profile pic on Appear")
                }
            }
            .onChange(of: user.image) {
                getPhoto(path: user.image)
                print("Getting profile pic on user.image change")
            }
            
            
            
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
                    loggedIn = false
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
                                 // Upload new profile picture to Firebase
                                if user.imageData == nil || user.imageData == Data() {
                                    Task {
                                        await editProfileLoader.editProfile(editProfileInput: EditTutorInput(tutorEmail: user.email, image: user.image, name: user.name, bio: user.bio ?? "", courses: getCourseStrings(courses: user.courses), price: user.price, availability: castAvailability(availability: user.availability)))
                                    }
                                }
                                else {
                                    Task {
                                        await uploadPhoto(imageToUpload: UIImage(data: user.imageData!)!)
                                    }
                                }
                            }
                        }
                    }
            }
        }
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
    
    func uploadPhoto(imageToUpload: UIImage) async -> Void {
        print("Hello dude")
        let storageRef = Storage.storage().reference()
        let imageData_ = imageToUpload.jpegData(compressionQuality: 0.8)
        
        guard imageData_ != nil else {
            return
        }
        let path = "Images/\(UUID().uuidString).jpg"
        user.image = path
        print("User.image: \(user.image)")
        print("Path: \(path)")
        let fileRef = storageRef.child(path)
        let uploadTask = fileRef.putData(imageData_!, metadata: nil) {metadata, error in
            if error == nil && metadata != nil {
                getPhoto(path: user.image)
            }
        }
        
        
        
        await editProfileLoader.editProfile(editProfileInput: EditTutorInput(tutorEmail: user.email, image: user.image, name: user.name, bio: user.bio ?? "", courses: getCourseStrings(courses: user.courses), price: user.price, availability: castAvailability(availability: user.availability)))
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
    @State static var loggedIn = true
    @State var cop: Int = 0
    @State static var profilePic: UIImage? = nil
    
    static var previews: some View {
        NavigationStack {
         UserProfile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, price: 0, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], favorites: [], availability: []), loggedIn: $loggedIn)
         }
        
    }
}

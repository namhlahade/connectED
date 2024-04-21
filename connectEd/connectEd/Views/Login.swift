import SwiftUI
import AuthenticationServices



struct LoginScreen: View {
    let addTutorLoader = AddTutorLoader()
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    @State var email: String = ""
    @State var validationStatus: Bool = false
    @State var loginError: String = ""
    @State var isPresentingProfileForm: Bool = false
    @State var editTutorFormData: Tutor.FormData = Tutor.FormData()
    @State var authorized: Bool = false
    
    @State var user: Tutor = Tutor(id: UUID(), name: "", email: "", bio: "", courses: [], image: Data(), status: .offline, rating: 0.0, price: 0, reviews: [], favorites: [], availability: [])
    
    var body: some View {
        if authorized {
            TabContainer(tutors: Tutor.previewData, email: $email)
        }
        else {
            ScrollView {
                TextFieldWithLabel(label: "Email", hint: "Make sure to include an @ in your email!", text: $email, validationStatus: $validationStatus, validationMessage: "You currently do not have an @ sign in your email") { email.contains("@") }
                Button("Login") {
                    authenticationService.login(email: email, modelContext: modelContext)
                    editTutorFormData = Tutor(name: "", email: email, courses: [], status: .offline, reviews: [], favorites: [], availability: []).dataForForm
                    isPresentingProfileForm.toggle()
                }
                .buttonStyle(.borderedProminent)
                if let errorMessage = authenticationService.errorMessage {
                    Text(errorMessage)
                        .font(.headline)
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Login")
            .padding().sheet(isPresented: $isPresentingProfileForm) {
                NavigationStack {
                    ProfileForm(data: $editTutorFormData)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    isPresentingProfileForm.toggle()
                                }
                                
                            }
                            ToolbarItem(placement: .principal) {
                                Text("Edit Profile").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Complete") {
                                    Tutor.update(user, from: editTutorFormData)
                                    authorized = true
                                    isPresentingProfileForm.toggle()
                                    Task{
                                        await addTutorLoader.addTutorInfo(tutor: AddTutorStruct(name: editTutorFormData.name, email: editTutorFormData.email, bio: editTutorFormData.bio, price: editTutorFormData.price, courses: getCourseStrings(courses: editTutorFormData.courses), availability: castAvailability(availability: editTutorFormData.availability)))
                                    }
                                }
                            }
                        }
                }
            }
        }
    }
    
    func stringDateGetter(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
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
    
    func handleFailedAppleAuthorization(_ error: Error) {
        print("Authorization Failed \(error)")
    }
}

func castAvailability(availability: [Availability]) -> [AvailabilityObject] {
    var ret: [AvailabilityObject] = []
    
    
    for avail in availability {
        ret.append(AvailabilityObject(day_of_week: Availability.Day.allCases.firstIndex(of: avail.day)!, start_time: stringDateGetter(avail.times[0]), end_time: stringDateGetter(avail.times[1])))
        print(stringDateGetter(avail.times[0]))
        print(stringDateGetter(avail.times[1]))
    }
    
    return ret
}

import SwiftUI
import AuthenticationServices



struct LoginScreen: View {
    let addTutorLoader = AddTutorLoader()
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    @State var email: String = ""
    @State private var isEmailValid = false
    @State var validationStatus: Bool = false
    @State var loginError: String = ""
    @State var isPresentingProfileForm: Bool = false
    @State var editTutorFormData: Tutor.FormData = Tutor.FormData()
    @State var authorized: Bool = false
    
    @State var user: Tutor = Tutor(id: UUID(), name: "", email: "", bio: "", courses: [], image: Data(), status: .offline, rating: 0.0, price: 0, reviews: [], favorites: [], availability: [])
    let backgroundColor = HexStringToColor(hex: "#3498eb").color
    var body: some View {
        if authorized {
            TabContainer(tutors: Tutor.previewData, email: $email)
        }
        else {
        VStack {
            ScrollView {
                Text("Welcome To ConnectED!")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(backgroundColor)
                                    .padding(.top, 50)
                TextField("Enter Email", text: $email)
                    .multilineTextAlignment(.center)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(backgroundColor, lineWidth: 1.5)
                    )                    .textFieldStyle(.roundedBorder)
                    .onChange(of: email) { newValue in
                        isEmailValid = newValue.contains("@") && newValue.contains(".")
                    }
                    .frame(height: 50)
                    .padding(30)
                Button("Login") {
                    authenticationService.login(email: email, modelContext: modelContext)
                    editTutorFormData = Tutor(name: "", email: email, courses: [], status: .offline, reviews: [], favorites: [], availability: []).dataForForm
                    isPresentingProfileForm.toggle()
                }
                .buttonStyle(.bordered)
                .disabled(!isEmailValid)
                Spacer()
                }.fontWeight(.bold)
                .foregroundColor(backgroundColor)
                .padding(30)
                .buttonStyle(.bordered).frame(maxWidth: .infinity)
                if let errorMessage = authenticationService.errorMessage {
                    Text(errorMessage)
                        .font(.headline)
                        .foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .center)
                }
            }.background(Color("#3498eb"))
                .edgesIgnoringSafeArea(.all)
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
                                        await addTutorLoader.addTutorInfo(tutor: AddTutorStruct(name: user.name, email: user.email, bio: user.bio ?? "", price: user.price, courses: getCourseStrings(courses: user.courses), availability: castAvailability(availability: user.availability)))
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

import SwiftUI
import AuthenticationServices



struct LoginScreen: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    @State var email: String = ""
    @State var validationStatus: Bool = false
    @State var loginError: String = ""
    @State var isPresentingProfileForm: Bool = false
    @State var editTutorFormData: Tutor.FormData = Tutor.FormData()
    @State var authorized: Bool = false
    var body: some View {
        if authorized {
            TabContainer(tutors: Tutor.previewData)
        }
        else {
            ScrollView {
                TextFieldWithLabel(label: "Email", hint: "Make sure to include an @ in your email!", text: $email, validationStatus: $validationStatus, validationMessage: "You currently do not have an @ sign in your email") { email.contains("@") }
                Button("Login") {
                    authenticationService.login(email: email, modelContext: modelContext)
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
                                    authorized = true
                                    isPresentingProfileForm.toggle()
                                }
                            }
                        }
                }
            }
        }
    }
    
    
    func handleFailedAppleAuthorization(_ error: Error) {
        print("Authorization Failed \(error)")
    }
}

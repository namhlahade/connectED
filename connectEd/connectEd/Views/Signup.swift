import SwiftUI

struct Signup: View {
    @State var isLoggedIn = false
    @State var email: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    NavigationLink(destination: InitProfile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], isFavorite: false, availability: []))) {
                        Text("Sign Up")
                    }.disabled(email.isEmpty)
                        .padding()
                        .foregroundColor(email.isEmpty ? Color.blue : Color.white)
                        .background(email.isEmpty ? Color.white : Color.blue)
                        .border(Color.blue, width: 5)
                        .cornerRadius(8)
                    
                    Spacer()
                }
                .navigationBarTitle("ConnectED")
                .padding()
                .navigationTitle("Welcome to ConnectED!")
                .alert(isPresented: $isLoggedIn) {
                    Alert(
                        title: Text("Signup Successful"),
                        message: Text("Welcome, \(email)!"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
}

#Preview {
    Signup()
}

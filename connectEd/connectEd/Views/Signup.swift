import SwiftUI
import SwiftData


struct Signup: View {
    @State var isLoggedIn = false
    @Environment(\.modelContext) private var modelContext
    @State private var email = ""
    @Query private var storedEmail: [Email]
    var body: some View {
        NavigationView {
            VStack {
                List(storedEmail) { em in
                        Text("Hello, \(em.userEmail)!")
                    }
                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    NavigationLink(destination: InitProfile()) {
                        Text("Sign Up")

                    }.disabled(email.isEmpty)
                        .padding()
                        .foregroundColor(email.isEmpty ? Color.blue : Color.white)
                        .background(email.isEmpty ? Color.white : Color.blue)
                        .border(Color.blue, width: 5)
                        .cornerRadius(8).onSubmit {
                            Email.create(email: email, context: modelContext)
                        }
                    
                    Spacer()
                }
                .navigationBarTitle("ConnectED")
                .padding()
                .navigationTitle("Welcome to ConnectED!")
            }
        }
    }
    
}

#Preview {
    let preview = PreviewContainer([Email.self])
    return NavigationStack {
        Signup()
            .modelContainer(preview.container)
    }
}

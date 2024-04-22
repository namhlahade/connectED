import Foundation
import SwiftData

@Observable
class FakeAuthenticationService {
    var currentUser: Email?
    var errorMessage: String?
    let currentUserKey: String = "currentUserKey"
    
    func login(email: String, modelContext: ModelContext) {
        let ws = CharacterSet.whitespacesAndNewlines
        modelContext.insert(Email(id: UUID(), userEmail: email))
        if let user = try? fetchUser(email, modelContext: modelContext) {
            errorMessage = nil
            loginUser(user)
        } else {
            errorMessage = "Login Failed"
            logout()
        }
    }
    
    func loginUser(_ user: Email) {
        currentUser = user
        UserDefaults.standard.set(user.userEmail, forKey: currentUserKey)
        UserDefaults.standard.synchronize()
    }
    
    func logout() {
        currentUser = nil
        UserDefaults.standard.set(nil, forKey: currentUserKey)
        UserDefaults.standard.synchronize()
    }
    
    func fetchUser(_ email: String, modelContext: ModelContext) throws -> Email? {
        let userPredicate = #Predicate<Email> { $0.userEmail == email }
        let userFetch = FetchDescriptor(predicate: userPredicate)
        return try modelContext.fetch(userFetch).first
    }
    
    func maybeLoginSavedUser(modelContext: ModelContext) -> String {
        let email = UserDefaults.standard.string(forKey: currentUserKey)
        if let email,
           let user = try? fetchUser(email, modelContext: modelContext) {
            loginUser(user)
            logout()
            return ""//user.userEmail
        }
        return ""
    }
    
}

import Foundation
import SwiftData

@Model class User {
  var email: String



  init(name: String, email: String) {
    self.email = email
  }
}

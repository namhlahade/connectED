import SwiftUI
import SwiftData

struct Favorites: View {
    var tutors: [Tutor] = []
    var body: some View {
        NavigationStack{
            List(tutors) {
                tutor in
                FavoritesRow(tutor: tutor)
            }
        }
    }
}

#Preview {
    Favorites(tutors: [Tutor(name: "James", email: "james@duke.edu", courses: [""], status: Status.online), Tutor(name: "Bob", email: "bob@duke.edu", courses: [""], status: Status.offline)])
}

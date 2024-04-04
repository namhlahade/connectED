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
    Favorites(tutors: [Tutor(name: "James", courses: [""], status: Status.online), Tutor(name: "Bob", courses: [""], status: Status.offline)])
}

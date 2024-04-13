import SwiftUI
import SwiftData

struct Favorites: View {
    //TODO: Ability to add and delete tutor from the favorites list?
    /*@Query (filter: #Predicate<Tutor> {$0.isFavorite}) private var tutors: [Tutor]
    @Environment(\.modelContext) private var modelContext*/
    var body: some View {
        /*NavigationStack{
            List(tutors) {
                tutor in
                FavoritesRow(tutor: tutor)
            }
            .navigationTitle("Favorites")
            .onAppear {
                if tutors.isEmpty {
                    for tutor in Tutor.previewData {
                        modelContext.insert(tutor)
                    }
                }
            }
        }*/
        Text("no more swiftdata so no favorites")
    }
}

#Preview {
    //let preview = PreviewContainer([Tutor.self])
    return NavigationStack {
        Favorites()
    }
    //.modelContainer(preview.container)
}

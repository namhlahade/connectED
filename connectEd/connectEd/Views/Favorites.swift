import SwiftUI
import SwiftData

struct Favorites: View {
    //TODO: Ability to add and delete tutor from the favorites list?
    /*@Query (filter: #Predicate<Tutor> {$0.isFavorite}) private var tutors: [Tutor]
     @Environment(\.modelContext) private var modelContext*/
    
    // Temporary line until SwiftData works again
    var tutors = Tutor.previewData.filter {$0.isFavorite}
    
    var body: some View {
        NavigationStack{
            List {
                ForEach (tutors) {
                    tutor in FavoritesRow(tutor: tutor)
                }
                .onDelete(perform: removeFavorite)
                .navigationTitle("Favorites")
//                .onAppear {
//                    if tutors.isEmpty {
//                        for tutor in Tutor.previewData {
//                            modelContext.insert(tutor)
//                        }
//                    }

                }
        
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        for offset in offsets {
            tutors[offset].isFavorite = false
        }
    }
}

#Preview {
    //let preview = PreviewContainer([Tutor.self])
    return NavigationStack {
        Favorites()
    }
    //.modelContainer(preview.container)
}

import SwiftUI
import SwiftData

struct Favorites: View {
    //TODO: Ability to add tutor to the favorites list (will need to add favorites form)
//    @Query (filter: #Predicate<Tutor> {$0.isFavorite}) private var tutors: [Tutor]
//    @Environment(\.modelContext) private var modelContext
    
    // Temporary line until SwiftData works again
    var tutors = Tutor.previewData
    @State var addFavorites = false
    
    var body: some View {
        NavigationStack{
            List {
                ForEach (tutors.filter {$0.isFavorite}) {
                    tutor in TutorRow(tutor: tutor)
                }

                .onDelete(perform: removeFavorite)
                .navigationTitle("Favorites")

//                .onAppear {
//                    if tutors.isEmpty {
//                        for tutor in Tutor.previewData {
//                            modelContext.insert(tutor)
//                        }
//                    }
//                    
//                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddFavoritesScreen(tutors: tutors.filter {$0.isFavorite == false})) {
                        Text("Add")
//                    Button("Add") {
//                        addFavorites.toggle()
//                    }
                }
            }
        }

            
        }

    }
    func removeFavorite(at offsets: IndexSet) {
        for offset in offsets {
            tutors[offset].isFavorite = false
        }
    }
}

struct AddFavoritesScreen: View {
    @State var tutors: [Tutor]
    var body: some View {
        List(tutors) { tutor in
            NavigationLink(destination: TutorDetails(tutor: tutor)){
                TutorRow(tutor: tutor)
            }
            .navigationTitle("Add to Favorites")
        }
    }
}

#Preview {
//    let preview = PreviewContainer([Tutor.self])
    return NavigationStack {
        Favorites()
    }
//    .modelContainer(preview.container)
}

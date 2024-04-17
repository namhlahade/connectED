import SwiftUI
import SwiftData

struct Favorites: View {
    //    @Query (filter: #Predicate<Tutor> {$0.isFavorite}) private var tutors: [Tutor]
    //    @Environment(\.modelContext) private var modelContext
    
    var tutors: [Tutor]
    @State var addFavorites = false
    
    var favoriteTutors: [Tutor] {
        tutors.filter {$0.isFavorite}
    }
    
    var body: some View {
        NavigationStack{
            List {
                ForEach (favoriteTutors) {
                    tutor in TutorRow(tutor: tutor)
                }
                
                .onDelete(perform: removeFavorite)
                
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
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
            }
            
            
        }
        .navigationTitle("Favorites")
        
    }
    func removeFavorite(at offsets: IndexSet) {
        for offset in offsets {
            favoriteTutors[offset].isFavorite = false
        }
    }
}


struct AddFavoritesScreen: View {
    @State var tutors: [Tutor]
    var body: some View {
        List(tutors) { tutor in
            HStack {
                TutorRow(tutor: tutor)
                Spacer()
                Button("Add") {
                    tutor.isFavorite.toggle()
                }
                Image(systemName: tutor.isFavorite ?  "checkmark.circle.fill": "circle")
                    .foregroundStyle(tutor.isFavorite ? Color.green: Color.black)
            }
            .navigationTitle("Add to Favorites")
        }
    }
}

#Preview {
    //    let preview = PreviewContainer([Tutor.self])
    return NavigationStack {
        Favorites(tutors: Tutor.previewData)
    }
    //    .modelContainer(preview.container)
}

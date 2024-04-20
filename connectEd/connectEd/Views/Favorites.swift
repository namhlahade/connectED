import SwiftUI
import SwiftData

struct Favorites: View {
    var tutors: [Tutor]
    @State var addFavorites = false
    
    var favoriteTutors: [Tutor] {
        tutors.filter {$0.isFavorite}
    }
    
    var body: some View {
        NavigationStack{
            List {
                ForEach (favoriteTutors) {
                    tutor in
                        NavigationLink(destination: TutorProfile(tutor: tutor)){
                            TutorRow(tutor: tutor)
                        }
                }
                
                .onDelete(perform: removeFavorite)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
            }
            
            
        }
        .navigationTitle("Favorite Tutors")
        
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
    return NavigationStack {
        Favorites(tutors: Tutor.previewData)
    }
}

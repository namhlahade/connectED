import SwiftUI
import SwiftData

struct ParentFavorites: View {
    let getTutorLoader = GetTutorLoader()
    var user: Tutor
    
    var body: some View {
    VStack {
      switch getTutorLoader.state {
      case .idle: Color.clear
      case .loading: ProgressView()
      case .failed(let error): Text("Error \(error.localizedDescription)")
      case .success(let allTutorInfo):
          Favorites(user: user, tutors: allTutorInfo.getTutors())
      }
    }
    .task { await getTutorLoader.getAllTutorInfo() }
  }
}

struct Favorites: View {
    
    @State var user: Tutor
    @State var tutors: [Tutor]
    
    @State var addFavorites = false
    
    var favoriteTutors: [Tutor] {
        tutors.filter {
            user.favorites.contains($0.email)
        }
    }
    
    var body: some View {
        NavigationStack{
            List {
                ForEach (favoriteTutors) {
                    tutor in
                    NavigationLink(destination: TutorProfile(user: user, tutor: tutor)){
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
            //favoriteTutors[offset].isFavorite = false
            user.favorites.remove(at: offset)
//            favoriteTutors.remove(at: offset)
            print(offset)
        }
    }
}


/*struct AddFavoritesScreen: View {
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
}*/

#Preview {
    return NavigationStack {
        Favorites(user: Tutor.previewData[0], tutors: Tutor.previewData)
    }
}

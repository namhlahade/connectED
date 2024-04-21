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
        .navigationTitle("Favorite Tutors")
        .task { await getTutorLoader.getAllTutorInfo() }
    }
}

struct Favorites: View {
    let deleteFavoritesLoader = DeleteFavoriteLoader()
    
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
                        TutorRow(user: user, tutor: tutor)
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
        
    }
    func removeFavorite(at offsets: IndexSet) {
        for offset in offsets {
            Task {
                await deleteFavoritesLoader.deleteFavoriteInfo(favoriteInput: FavoriteInputStruct(userEmail: user.email, tutorEmail: favoriteTutors[offset].email))
            }
            user.favorites.remove(at: user.favorites.firstIndex(of: favoriteTutors[offset].email)!)
        }
    }
}

#Preview {
    return NavigationStack {
        Favorites(user: Tutor.previewData[0], tutors: Tutor.previewData)
    }
}

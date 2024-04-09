import SwiftUI
import SwiftData

struct Favorites: View {
    @Query private var tutors: [Tutor]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack{
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
        }
    }
}

#Preview {
    let preview = PreviewContainer([Tutor.self])
    return NavigationStack {
        Favorites()
    }
    .modelContainer(preview.container)
}

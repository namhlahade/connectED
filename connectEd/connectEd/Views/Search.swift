import SwiftUI
import SwiftData

struct Search: View {
    @State var searchText: String = ""
    @State var tutors: [Tutor]
    var body: some View {
        NavigationStack {
            List(tutors) { tutor in
                NavigationLink(destination: TutorDetails(tutor: tutor)){
                    TutorRow(tutor: tutor)
                }
            }
            Text("Search page. Whoever does this will primarily be working with SwiftData and the API call from the Browse page.")
                .navigationTitle("Your Saviors")
                .onAppear() {
                    tutors = Tutor.previewData
                }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    Search(tutors: Tutor.previewData)
}

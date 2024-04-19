import SwiftUI
import SwiftData

struct Search: View {
    //TODO: Sort the tutors based on online or offline
    @State var searchText: String = ""
    @State var tutors: [Tutor]
    var body: some View {
            List(tutors) { tutor in
                NavigationLink(destination: TutorProfile(tutor: tutor)){
                    TutorRow(tutor: tutor)
                }
            }
            .navigationTitle("Your Saviors")
            .onAppear() {
                tutors = Tutor.previewData
            }
        .searchable(text: $searchText)
    }
}

#Preview {
    Search(tutors: Tutor.previewData)
}

import SwiftUI
import SwiftData

struct Search: View {
    @State var searchText: String = ""
    @State var tutors: [Tutor]
    
    var availableTutors: [Tutor] {
        tutors.filter {$0.status == Status.online}
    }
    
    var unavailableTutors: [Tutor] {
        tutors.filter {$0.status == Status.offline}
    }
    
    var body: some View {
        List(availableTutors) { tutor in
            NavigationLink(destination: TutorProfile(tutor: tutor)){
                TutorRow(tutor: tutor)
            }
        }
        List(unavailableTutors) { tutor in
            NavigationLink(destination: TutorProfile(tutor: tutor)){
                TutorRow(tutor: tutor)
            }
        }
        .navigationTitle("Your Saviors")
        .searchable(text: $searchText)
    }
}

#Preview {
    NavigationStack {
        Search(tutors: Tutor.previewData)
    }
}

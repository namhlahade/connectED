import SwiftUI
import SwiftData

struct Search: View {
    @State private var searchText: String = ""
    @State private var advancedFiltering: Bool = false
    @State var tutors: [Tutor]
    
    var availableTutors: [Tutor] {
        tutors.filter {$0.status == Status.online}
    }
    
    var unavailableTutors: [Tutor] {
        tutors.filter {$0.status == Status.offline}
    }
    
    
    var body: some View {
        //TODO: Use an if/else statement for simple search vs advanced search features with sheet/form
        SimpleSearchScreen(searchText: $searchText, availableTutors: availableTutors, unavailableTutors: unavailableTutors)
    }
}

struct SimpleSearchScreen: View {
    @Binding var searchText: String
    var availableTutors: [Tutor]
    var unavailableTutors: [Tutor]
    
    
    var nameSearchAvailableTutors: [Tutor] {
        availableTutors.filter {$0.name.contains(searchText)}
    }
    
    var nameSearchUnavailableTutors: [Tutor] {
        unavailableTutors.filter {$0.name.contains(searchText)}
    }
    
    var body: some View {
        List(searchText == "" ? availableTutors: nameSearchAvailableTutors) { tutor in
            NavigationLink(destination: TutorProfile(tutor: tutor)){
                TutorRow(tutor: tutor)
            }
        }
        List(searchText == "" ? unavailableTutors: nameSearchUnavailableTutors) { tutor in
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

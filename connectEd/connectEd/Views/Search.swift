import SwiftUI
import SwiftData

struct Search: View {
    @State private var searchText: String = ""
    @State private var advancedSearch: Bool = false
    @State var tutors: [Tutor]
    
    var availableTutors: [Tutor] {
        tutors.filter {$0.status == Status.online}
    }
    
    var unavailableTutors: [Tutor] {
        tutors.filter {$0.status == Status.offline}
    }
    
    
    
    
    var body: some View {
        //TODO: Use an if/else statement for simple search vs advanced search features with sheet/form
        //TODO: Use an original screen with propogated tutors and send it using a NavigationLink to two different screens
        var nameSearchAvailableTutors: [Tutor] {
            availableTutors.filter {$0.name.contains(searchText)}
        }
        
        var nameSearchUnavailableTutors: [Tutor] {
            unavailableTutors.filter {$0.name.contains(searchText)}
        }
        
        
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Advanced Search") {
                    advancedSearch.toggle()
                }
            }
        }
        .sheet(isPresented: $advancedSearch) {
            NavigationStack {
                AdvancedSearchForm()
            }
        }
        
    }
}

struct AdvancedSearchForm: View {
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    NavigationStack {
        Search(tutors: Tutor.previewData)
    }
}

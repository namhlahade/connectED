import SwiftUI
import SwiftData

struct Search: View {
    @State private var searchText: String = ""
    @State private var advancedSearch: Bool = false
    @State var rating: Double = 0.0
    @State var price: Int = 40
    @State var availableOnly: Bool = false
    @State var tutors: [Tutor]
    @State var courses: [Course] = []
    
    var body: some View {
        var searchTutors: [Tutor] {
            if searchText == "" {
                tutors.filter
                {tutor in (tutor.rating >= rating || tutor.rating == 0.0) &&
                    tutor.price <= Double(price) && courses.allSatisfy {tutorCourse in tutor.courses.contains {$0.code == tutorCourse.code && $0.subject == tutorCourse.subject}}}
            }
            else {
                tutors.filter
                {tutor in tutor.name.contains(searchText) && (tutor.rating >= rating || tutor.rating == 0.0) &&
                    tutor.price <= Double(price) && courses.allSatisfy {tutorCourse in tutor.courses.contains {$0.code == tutorCourse.code && $0.subject == tutorCourse.subject}}}
            }
        }
        
        List(availableOnly ? searchTutors.filter {$0.status == Status.online} : searchTutors) { tutor in
            NavigationLink(destination: TutorProfile(tutor: tutor)){
                TutorRow(tutor: tutor)
            }
        }
        .navigationTitle("Get ConnectED")
        .searchable(text: $searchText, prompt: "Search for Name")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Filters") {
                    advancedSearch.toggle()
                }
            }
        }
        .sheet(isPresented: $advancedSearch) {
            NavigationStack {
                AdvancedSearchForm(rating: $rating, price: $price, availableOnly: $availableOnly, courses: $courses)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Advanced Search").bold()
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Apply") {
                                advancedSearch.toggle()
                            }
                        }
                    }
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        Search(tutors: Tutor.previewData)
    }
}

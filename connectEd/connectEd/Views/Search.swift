import SwiftUI
import SwiftData

struct ParentSearch: View {
    let getTutorLoader = GetTutorLoader()
    var user: Tutor
    
    var body: some View {
        VStack {
            switch getTutorLoader.state {
            case .idle: Color.clear
            case .loading: ProgressView()
            case .failed(let error): Text("Error \(error.localizedDescription)")
            case .success(let allTutorInfo):
                Search(user: user, tutors: allTutorInfo.getTutors().filter {$0.email != user.email})
            }
        }
        .task { await getTutorLoader.getAllTutorInfo() }
        .navigationTitle("Get ConnectED")
    }
}

struct Search: View {
    @State private var searchText: String = ""
    @State private var advancedSearch: Bool = false
    @State var rating: Double = 0.0
    @State var price: Int = 40
    @State var availableOnly: Bool = false
    @State var user: Tutor
    @State var tutors: [Tutor]
    @State var courses: [Course] = []
    
    var body: some View {
        var searchTutors: [Tutor] {
            if searchText == "" {
                tutors.filter
                {tutor in (tutor.rating > rating || tutor.rating == 0.0) &&
                    tutor.price <= Double(price) && courses.allSatisfy {tutorCourse in tutor.courses.contains {$0.code == tutorCourse.code && $0.subject == tutorCourse.subject}}}
            }
            else {
                tutors.filter
                {tutor in tutor.name.contains(searchText) && (tutor.rating >= rating || tutor.rating == 0.0) &&
                    tutor.price <= Double(price) && courses.allSatisfy {tutorCourse in tutor.courses.contains {$0.code == tutorCourse.code && $0.subject == tutorCourse.subject}}}
            }
        }
        
        List(availableOnly ? searchTutors.filter {$0.status == Status.online} : searchTutors) { tutor in
            NavigationLink(destination: TutorProfile(user: user, tutor: tutor)){
                TutorRow(user: user, tutor: tutor)
            }
        }
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
                            Button("Exit") {
                                advancedSearch.toggle()
                            }
                        }
                    }
            }
        }
    }
}

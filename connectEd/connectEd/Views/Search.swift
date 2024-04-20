import SwiftUI
import SwiftData

struct Search: View {
    @State private var searchText: String = ""
    @State private var advancedSearch: Bool = false
    @State var rating: Double = 0.0
    @State var price: Int = 40
    @State var availableOnly: Bool = false
    @State var tutors: [Tutor]
    
    //    var availableTutors: [Tutor] {
    //        tutors.filter {$0.status == Status.online}
    //    }
    
    var body: some View {
        var searchTutors: [Tutor] {
            if searchText == "" {
                tutors.filter
                {$0.rating >= rating &&
                    $0.price <= Double(price)}
            }
            else {
                tutors.filter
                {$0.name.contains(searchText) &&
                    $0.rating >= rating && $0.price <= Double(price)}
            }
        }
        
        Form {
            Section(header: Text("Tutors")) {
                List(availableOnly ? searchTutors.filter {$0.status == Status.online} : searchTutors) { tutor in
                    NavigationLink(destination: TutorProfile(tutor: tutor)){
                        TutorRow(tutor: tutor)
                    }
                }
            }
        }
        .navigationTitle("Your Saviors")
        .searchable(text: $searchText, prompt: "Search for Name")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Filters") {
                    advancedSearch.toggle()
                }
            }
        }
        .sheet(isPresented: $advancedSearch) {
            NavigationStack {
                AdvancedSearchForm(rating: $rating, price: $price, availableOnly: $availableOnly)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Advanced Search").bold()
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Apply Filters") {
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

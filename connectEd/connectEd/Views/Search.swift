import SwiftUI
import SwiftData

struct Search: View {
    @State private var searchText: String = ""
    @State private var advancedSearch: Bool = false
    @State private var rating: Double = 0.0
    @State private var price: Double = 0.0
    @State var tutors: [Tutor]
    
    let ratingScale = ["Poor", "Fair", "Average", "Good", "Excellent"]
    let starColor = HexStringToColor(hex: "#3498eb").color
    
    var availableTutors: [Tutor] {
        tutors.filter {$0.status == Status.online}
    }
    
    var unavailableTutors: [Tutor] {
        tutors.filter {$0.status == Status.offline}
    }
    
    var body: some View {
        var searchAvailableTutors: [Tutor] {
            if searchText == "" {
                availableTutors.filter
                {$0.rating >= rating &&
                    $0.price <= price}
            }
            else {
                availableTutors.filter
                {$0.name.contains(searchText) &&
                    $0.rating >= rating && $0.price <= price}
            }
        }
        
        var searchUnavailableTutors: [Tutor] {
            if searchText == "" {
                unavailableTutors.filter
                {$0.rating >= rating && $0.price <= price}
            }
            else {
                unavailableTutors.filter
                {$0.name.contains(searchText) &&
                    $0.rating >= rating && $0.price <= price}
            }
        }
        
        Form {
            
            //                    Picker(selection: $tutors.courses, label: Text("Courses").modifier(FormLabel())) {
            //                        ForEach(courses) {
            //                            course in Text(course.rawValue)
            //                        }
            //                    }
            //                    .pickerStyle(.menu)
            Section(header: Text("Filter by rating")) {
                RatingSlider(value: $rating, scale: ratingScale, color: starColor)
            }
            Section(header: Text("Filter by price")) {
                //                RatingSlider(value: $price, scale: ratingScale, color: starColor)
                Picker(selection: $price, label: Text("Prices")) {
                    ForEach(0..<50) {
                        price in Text("\(price)")
                    }
                }
            }
            Section(header: Text("Available Tutors")) {
                List(searchAvailableTutors) { tutor in
                    NavigationLink(destination: TutorProfile(tutor: tutor)){
                        TutorRow(tutor: tutor)
                    }
                }
            }
            Section(header: Text("Unavailable Tutors")) {
                List(searchUnavailableTutors) { tutor in
                    NavigationLink(destination: TutorProfile(tutor: tutor)){
                        TutorRow(tutor: tutor)
                    }
                }
            }
        }
        .navigationTitle("Your Saviors")
        .searchable(text: $searchText, prompt: "Search for Name")
    }
}

#Preview {
    NavigationStack {
        Search(tutors: Tutor.previewData)
    }
}

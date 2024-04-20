import SwiftUI
import SwiftData

struct Search: View {
    @State private var searchText: String = ""
    @State private var advancedSearch: Bool = false
    @State private var rating: Double = 0.0
    @State private var price: Int = 40
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
                    $0.price <= Double(price)}
            }
            else {
                availableTutors.filter
                {$0.name.contains(searchText) &&
                    $0.rating >= rating && $0.price <= Double(price)}
            }
        }
        
        var searchUnavailableTutors: [Tutor] {
            if searchText == "" {
                unavailableTutors.filter
                {$0.rating >= rating && $0.price <= Double(price)}
            }
            else {
                unavailableTutors.filter
                {$0.name.contains(searchText) &&
                    $0.rating >= rating && $0.price <= Double(price)}
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
            //TODO: Figure out why picker isn't showing or working correctly?
            Section(header: Text("Filter by price")) {
                Picker(selection: $price, label: Text("Price")) {
                    ForEach(0..<50) {
                        index in Text("\(index)")
                    }
                }
                .pickerStyle(.menu)
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

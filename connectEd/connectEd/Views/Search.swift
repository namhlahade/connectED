import SwiftUI
import SwiftData

struct Search: View {
    @State private var searchText: String = ""
    @State private var advancedSearch: Bool = false
    @State private var rating: Double = 0.0
    @State private var price: Int = 40
    @State private var availableOnly: Bool = false
    @State var tutors: [Tutor]
    
    let ratingScale = ["Poor", "Fair", "Average", "Good", "Excellent"]
    let starColor = HexStringToColor(hex: "#3498eb").color
    
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
                Picker(selection: $price, label: Text("Price")) {
                    ForEach(0..<50) {
                        index in Text("\(index)")
                    }
                }
                .pickerStyle(.menu)
            }
            Section(header: Text("Tutors")) {
                List(searchTutors) { tutor in
                    NavigationLink(destination: TutorProfile(tutor: tutor)){
                        TutorRow(tutor: tutor)
                    }
                }
            }
        }
        .navigationTitle("Your Saviors")
        .searchable(text: $searchText, prompt: "Search for Name")
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button(availableOnly ? "All Tutors": "Only Available Tutors") {
//                    availableOnly.toggle()
//                }
//            }
//        }
    }
}

#Preview {
    NavigationStack {
        Search(tutors: Tutor.previewData)
    }
}

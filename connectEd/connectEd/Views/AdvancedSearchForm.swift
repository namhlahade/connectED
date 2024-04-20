import SwiftUI

struct AdvancedSearchForm: View {
    @Binding var rating: Double
    @Binding var price: Int
    @Binding var availableOnly: Bool
    
    let ratingScale = ["Poor", "Fair", "Average", "Good", "Excellent"]
    let starColor = HexStringToColor(hex: "#3498eb").color
    
    var body: some View {
        Form {
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
            Section(header: Text("Filter by availability")) {
                HStack {
                    Button("Only Available Tutors") {
                        availableOnly.toggle()
                    }
                    Spacer()
                    Image(systemName: availableOnly ? "checkmark.circle": "circle")
                        .foregroundStyle(availableOnly ? Color.green : Color.blue)
                }
            }
//            Section(header: Text("Filter by courses")) {
//                Picker(selection: $tutors.courses, label: Text("Courses").modifier(FormLabel())) {
//                    ForEach(courses) {
//                        course in Text(course.rawValue)
//                    }
//                }
//                .pickerStyle(.menu)
//            }
        }
    }
}

#Preview {
    AdvancedSearchForm(rating: Binding.constant(1.0), price: Binding.constant(40), availableOnly: Binding.constant(false))
}

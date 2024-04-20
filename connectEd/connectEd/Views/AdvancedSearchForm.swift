import SwiftUI

struct AdvancedSearchForm: View {
    @Binding var rating: Double
    @Binding var price: Int
    @Binding var availableOnly: Bool
    @Binding var courses: [Course]
    
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
            Section(header: Text("Filter by courses")) {
                ForEach(Array($courses.enumerated()), id: \.offset) { index, element in
                    HStack {
                        
                        Picker("", selection: $courses[index].subject) {
                            ForEach(Tutor.Subject.allCases) { subject in
                                Text(subject.rawValue.uppercased())
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        
                        TextField("Class code", text: $courses[index].code, prompt: Text("Class code"))
                        
                        Button("", systemImage: "x.circle") {
                            courses.remove(at: index)
                        }.buttonStyle(BorderlessButtonStyle())
                        
                    }
                }
                
                Button("Add course", systemImage: "plus.circle") {
                    courses.append(Course(subject: .ece, code: "101"))
                }.buttonStyle(BorderlessButtonStyle())
            }
            ForEach(courses) { course in
                Text(course.subject.rawValue)
                Text(course.code)
            }
        }
    }
}

#Preview {
    AdvancedSearchForm(rating: Binding.constant(1.0), price: Binding.constant(40), availableOnly: Binding.constant(false), courses: Binding.constant([Course(subject: .ece, code: "350")]))
}

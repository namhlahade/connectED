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
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
            }
            Section(header: Text("Filter by availability")) {
                HStack {
                    Button("Only show available tutors") {
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
                        
                        Button("", systemImage: "minus.circle.fill") {
                            courses.remove(at: index)
                        }.buttonStyle(BorderlessButtonStyle()).foregroundStyle(Color.red)
                        
                    }
                }
                
                
                Button(action: {
                    courses.append(Course(subject: .ece, code: "101"))
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                        Text("Add course")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

#Preview {
    AdvancedSearchForm(rating: Binding.constant(1.0), price: Binding.constant(40), availableOnly: Binding.constant(false), courses: Binding.constant([Course(subject: .ece, code: "350")]))
}

import SwiftUI

struct ReviewForm: View {
    @State private var course: String = ""
    @State private var rating: Int = 0
    @State private var clarityRating: Double = 0
    @State private var understandingRating: Double = 0
    @State private var additionalComments: String = ""
    
    let ratingScale = ["Poor", "Fair", "Average", "Good", "Excellent"]
    let starColor = HexStringToColor(hex: "#3498eb").color
    
    var body: some View {
        Form {
            Section(header: Text("Tutor")) {
                HStack {
                    Spacer()
                    Text("TUTOR_NAME")
                    Spacer()
                }
            }
            
            Section(header: Text("Course Being Tutored")) {
                TextField("Course", text: $course)
                    .multilineTextAlignment(.center)
            }
            
            Section(header: Text("Overall Rating")) {
                HStack {
                    Spacer()
                    ForEach(1...5, id: \.self) { index in
                        Button(action: {
                            self.rating = index
                        }) {
                            Image(systemName: self.getStarImageName(for: index))
                                .foregroundColor(self.starColor)
                                .font(.system(size: 25))
                        }.buttonStyle(.plain)
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Clarity")) {
                RatingSlider(value: $clarityRating, scale: ratingScale, color: starColor) // Pass star color to RatingSlider
            }
            
            Section(header: Text("Preparation")) {
                RatingSlider(value: $understandingRating, scale: ratingScale, color: starColor) // Pass star color to RatingSlider
            }
            
            Section(header: Text("Additional Comments")) {
                TextEditor(text: $additionalComments)
                    .frame(height: 100)
            }
            
            Button(action: {
            }) {
                Text("Submit Review")
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarTitle("Leave a Review")
    }

    private func getStarImageName(for index: Int) -> String {
        if index <= self.rating {
            return "star.fill"
        } else {
            return "star"
        }
    }
}

struct RatingSlider: View {
    @Binding var value: Double
    let scale: [String]
    let color: Color // Receive star color
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Slider(value: $value, in: 0...Double(scale.count - 1), step: 1)
                    .accentColor(color) // Set accent color for slider
                Spacer()
            }
            HStack(spacing: 0) {
                ForEach(scale, id: \.self) { label in
                    Spacer()
                    Text(label)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
    }
}

struct ReviewForm_Previews: PreviewProvider {
    static var previews: some View {
        ReviewForm()
    }
}

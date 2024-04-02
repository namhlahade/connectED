
import SwiftUI

struct ReviewForm: View {
    @State private var course: String = ""
    @State private var rating: Int = 2
    @State private var clarityRating: Double = 0
    @State private var understandingRating: Double = 0
    @State private var additionalComments: String = ""
    
    let ratingScale = ["Poor", "Fair", "Average", "Good", "Excellent"]
    
    var body: some View {
        Form {
            Section(header: Text("Tutor")){
                Text("TUTOR_NAME")
            }
            
            Section(header: Text("Course Being Tutored")) {
                TextField("Course", text: $course)
            }
            
            Section(header: Text("Overall Rating")) {
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Button(action: {
                            self.rating = index
                        }) {
                            Image(systemName: self.getStarImageName(for: index))
                                .foregroundColor(self.getStarColor(for: index))
                                .font(.system(size: 25))
                        }.buttonStyle(.plain)
                    }
                }
            }
            
            Section(header: Text("Clarity")) {
                RatingSlider(value: $clarityRating, scale: ratingScale)
            }
            
            Section(header: Text("Understanding of Content")) {
                RatingSlider(value: $understandingRating, scale: ratingScale)
            }
            
            Section(header: Text("Additional Comments")) {
                TextEditor(text: $additionalComments)
                    .frame(height: 100)
            }
            
            Button(action: {
            }) {
                Text("Submit Review")
            }
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

    private func getStarColor(for index: Int) -> Color {
        if index <= self.rating {
            return .yellow
        } else {
            return .gray
        }
    }
}

struct RatingSlider: View {
    @Binding var value: Double
    let scale: [String]
    
    var body: some View {
        VStack {
            HStack {
                Slider(value: $value, in: 0...Double(scale.count - 1), step: 1)
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

#Preview {
    ReviewForm()
}

import SwiftUI

struct ReviewForm: View {
    
    @Bindable var tutor: Tutor

    @Environment(\.presentationMode) var presentationMode
    /*@State private var course: Course = Course(subject: .ece, code: "101")
    @State private var rating: Int = 0
    @State private var clarityRating: Double = 0
    @State private var understandingRating: Double = 0
    @State private var additionalComments: String = ""*/
    
    @State private var review: Review = Review(email: "", rating: 0, clarity: 0, prep: 0, review: "")
    let addTutorReviewLoader = AddTutorReviewLoader()
    let ratingScale = ["Poor", "Fair", "Average", "Good", "Excellent"]
    let starColor = HexStringToColor(hex: "#3498eb").color
    
    var body: some View {
        Form {
            Section(header: Text("Tutor")) {
                HStack {
                    Spacer()
                    Text(tutor.name)
                    Spacer()
                }
            }
            
            Section(header: Text("Overall Rating")) {
                HStack {
                    Spacer()
                    ForEach(1...5, id: \.self) { index in
                        Button(action: {
                            review.rating = Double(index)
                        }) {
                            Image(systemName: getStarImageName(for: index, review: review))
                                .foregroundColor(self.starColor)
                                .font(.system(size: 25))
                        }.buttonStyle(.plain)
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Clarity")) {
                RatingSlider(value: $review.clarity, scale: ratingScale, color: starColor)
            }
            
            Section(header: Text("Preparation")) {
                RatingSlider(value: $review.prep, scale: ratingScale, color: starColor)
            }
            
            Section(header: Text("Additional Comments")) {
                TextEditor(text: $review.review)
                    .frame(height: 100)
            }
            
            Button(action: {
                print(review)
                review.email = tutor.email
                // TODO: submit review to user here through API
                self.presentationMode.wrappedValue.dismiss()
                Task {
                    await addTutorReviewLoader.addTutorReview(tutorReviewInput: TutorReviewInputStruct(rating: Int(review.rating), clarity: Int(review.clarity), prep: Int(review.prep), review: review.review, tutorEmail: tutor.email))
                }
            }) {
                Text("Submit Review").fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarTitle("Leave a Review")
//        switch addTutorReviewLoader.state {
//            case .idle: Color.clear
//            case .loading: ProgressView()
//            case .failed(let error): ScrollView { Text("Error \(error.localizedDescription)") }
//            case .success(let message):
//                ReviewForm(tutor: tutor)
//            
//        }
    }

}

func getStarImageName(for index: Int, review: Review) -> String {
    if Double(index) <= review.rating {
        return "star.fill"
    } else {
        return "star"
    }
}


struct RatingSlider: View {
    @Binding var value: Double
    let scale: [String]
    let color: Color

    var body: some View {
        VStack {
            Text("\(scale[Int(value)])") 
                .font(.headline)
                .foregroundColor(color)
                .padding(.bottom, 2)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Slider(value: $value, in: 0...Double(scale.count - 1), step: 1)
                        .accentColor(color)
                        .accessibilityLabel("Rating Slider")
                }
            }
            .frame(height: 30) // Providing enough space for tick marks
        }
    }
}





struct ReviewForm_Previews: PreviewProvider {
    static var previews: some View {
        ReviewForm(tutor: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, price: 0, reviews: [], favorites: [], availability: []))
    }
}

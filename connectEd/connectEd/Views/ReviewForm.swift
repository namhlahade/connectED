import SwiftUI

struct ReviewForm: View {
    
    @Bindable var tutor: Tutor
    
    @Environment(\.presentationMode) var presentationMode
    
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
            
        }
        .navigationBarTitle("Leave a Review")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() 
                    Task {
                        review.email = tutor.email
                        let totalRatingSoFar = tutor.rating * Double(tutor.reviews.count)
                        let updatedTotalRating = totalRatingSoFar + review.rating
                        let updatedReviewCount = tutor.reviews.count + 1
                        tutor.rating = updatedTotalRating / Double(updatedReviewCount)
                        tutor.reviews.append(review)
                        
                        await addTutorReviewLoader.addTutorReview(tutorReviewInput: TutorReviewInputStruct(rating: Int(review.rating), clarity: Int(review.clarity), prep: Int(review.prep), review: review.review, tutorEmail: tutor.email))
                    }
                }) {
                    Text("Submit")
                }
                .frame(maxWidth: .infinity)
                
            }
        }
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
                    Slider(value: $value, in: 0...Double(scale.count - 1 ), step: 1)
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

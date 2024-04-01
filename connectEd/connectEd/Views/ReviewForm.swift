
import SwiftUI

struct ReviewForm: View {
    @State private var course: String = ""
    @State private var rating: Int = 0
    @State private var additionalComments: String = ""
    var body: some View {
        Form {
            Section(header: Text("Course Being Tutored")) {
                TextField("Course", text: $course)
            }
            
            
            Section(header: Text("Rating")) {
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Button(action: {
                            self.rating = index
                        }) {
                            Image(systemName: self.getStarImageName(for: index))
                                .foregroundColor(self.getStarColor(for: index))
                                .font(.system(size: 25))
                        }
                    }
                }
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


#Preview {
    ReviewForm()
}

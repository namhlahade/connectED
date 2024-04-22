import SwiftUI

struct RatingView: View {
     @Binding var rating: Double

    var ratingColor: Color {
        switch rating {
        case 0...2:
            return .red
        case 2...3.5:
            return  .orange
        case 3.5...5:
            return .green
        default:
            return .gray
        }
    }

    var body: some View {
        Text(rating == 0 ? String(format: "Rating: --") : String(format: "Rating: %.1f", rating))
            .foregroundColor(rating != 0 ? ratingColor : .gray)
            .padding(5)
            .background(rating != 0 ? ratingColor.opacity(0.2) : .gray.opacity(0.2))
            .cornerRadius(10)
            .font(.footnote)
    }
}

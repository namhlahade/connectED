import SwiftUI

struct PriceView: View {
    @Binding var price: Double

    // Computed property to get color based on the price
    var priceColor: Color {
        switch price {
        case 0..<20:
            return .green  // Cheap
        case 20..<50:
            return .orange  // Moderately expensive
        case 50...:
            return .red  // Expensive
        default:
            return .gray  // Undefined or zero
        }
    }

    var body: some View {
        Text(price == 0 ? "-- Per Hour" : String(format: "$%.2f Per Hour", price))
            .foregroundColor(price != 0 ? priceColor : .gray)
            .padding(5)
            .background(price != 0 ? priceColor.opacity(0.2) : .gray.opacity(0.2))
            .cornerRadius(10)
            .font(.caption)  // You can adjust the font size as needed
    }
}

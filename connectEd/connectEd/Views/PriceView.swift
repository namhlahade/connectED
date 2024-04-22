import SwiftUI

struct PriceView: View {
    @Binding var price: Double

    var priceColor: Color {
        switch price {
        case 0..<20:
            return .green
        case 20..<50:
            return .orange
        case 50...:
            return .red
        default:
            return .gray
        }
    }

    var body: some View {
        Text(price == 0 ? "-- Per Hour" : String(format: "$%.2f Per Hour", price))
            .foregroundColor(price != 0 ? priceColor : .gray)
            .padding(5)
            .background(price != 0 ? priceColor.opacity(0.2) : .gray.opacity(0.2))
            .cornerRadius(10)
            .font(.caption)
    }
}

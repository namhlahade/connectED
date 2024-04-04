import SwiftUI
import SwiftData

struct Search: View {
    @State var searchText: String = ""
    var body: some View {
        NavigationStack {
            Text("Search page. Whoever does this will primarily be working with SwiftData and the API call from the Browse page.")
                .navigationTitle("Your Saviors")
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    Search()
}

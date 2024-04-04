import SwiftUI

struct FavoritesRow: View {
    let tutor: Tutor
    var body: some View {
        HStack {
            AsyncImage(url: tutor.image)
            { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            placeholder: {
                if tutor.image != nil {
                    ProgressView()
                } else {
                    Image(systemName: "person.fill")
                }
            }
            VStack (alignment: .leading) {
                Text(tutor.name).bold().font(.title)
                Text("Bio")
                Text("Courses: ")
                Text(tutor.status.rawValue)
            }
        }
        
    }
}

#Preview {
    FavoritesRow(tutor: Tutor(name: "James", email: "james@duke.edu", courses: [""], status: Status.online))
}
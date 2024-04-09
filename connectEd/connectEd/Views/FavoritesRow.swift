import SwiftUI

struct FavoritesRow: View {
    @Bindable var tutor: Tutor
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: tutor.image ?? ""))
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
    let preview = PreviewContainer([Tutor.self])
//    let tutor = Tutor.previewData[0]
    let tutor = Tutor(name: "James", email: "james@duke.edu", courses: [""], status: Status.online)
    return FavoritesRow(tutor: tutor).modelContainer(preview.container)
}

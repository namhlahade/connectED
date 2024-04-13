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
                Text(tutor.bio ?? "No Bio Info").foregroundStyle(Color.gray)
                Text("Courses: ").bold()
                HStack {
                    Image(systemName: "circle.fill").foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    Text(tutor.status.rawValue.capitalized)
                }
                
                
            }
        }
        
    }
}

#Preview {
    //let preview = PreviewContainer([Tutor.self])
    let tutor = Tutor.previewData[0]
    return FavoritesRow(tutor: tutor)//.modelContainer(preview.container)
}

import SwiftUI

struct TutorRow: View {
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
            //TODO: Maybe find a different way to display courses?
            VStack (alignment: .leading) {
                Text(tutor.name).bold().font(.title)
                Text(tutor.bio ?? "No Bio Info").foregroundStyle(Color.gray)
                HStack {
                    Text("Courses: ").bold()
                    if tutor.courses.isEmpty == false {
                        ForEach(tutor.courses) {
                            course in
                            Text(course.subject.rawValue)
                        }
                    }
                    else {
                        Text("None")
                    }
                }

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
    return TutorRow(tutor: tutor)//.modelContainer(preview.container)
}

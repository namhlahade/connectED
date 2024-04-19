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
            VStack (alignment: .leading) {
                HStack {
                    Text(tutor.name).bold().font(.title)
                    Spacer()
                    Image(systemName: "circle.fill").foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    Text(tutor.status.rawValue.capitalized)
                }
                
                Text(tutor.bio ?? "No Bio Info").foregroundStyle(Color.gray)
                HStack {
                    Text("Courses: ").bold()
                    if tutor.courses.isEmpty == false {
                        VStack {
                            ForEach(tutor.courses) {
                                course in
                                Text(course.subject.rawValue.uppercased() + " " + course.code)
                            }
                        }
                    }
                    else {
                        Text("None")
                    }
                }
            }
        }
        
    }
}

#Preview {
    let tutor = Tutor.previewData[1]
    return TutorRow(tutor: tutor)
}

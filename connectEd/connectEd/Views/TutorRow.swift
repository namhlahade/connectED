import SwiftUI

struct ParentStruct_TutorRow: View {
    @Bindable var tutor: Tutor
    let getTutorInfoLoader = GetTutorInfoLoader()
    var body: some View {
      VStack {
        switch getTutorInfoLoader.state {
        case .idle: Color.clear
        case .loading: ProgressView()
        case .failed(let error): TutorRow(tutor: tutor)
        case .success(let tutorInfo):
          TutorRow(tutor: tutor)
        }
      }
      .task { await getTutorInfoLoader.getTutorInfo(email: EmailStruct(tutorEmail: tutor.email)) }
    }
}

struct TutorRow: View {
    @State var tutor: Tutor
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

//#Preview {
//    let tutor = Tutor.previewData[1]
//    return TutorRow(tutor: tutor)
//}

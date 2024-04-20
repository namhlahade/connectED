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
            if (tutor.image == Data() || tutor.image == nil) {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, maxHeight: 200)
                    .padding()
                
            }
            else {
                Image(uiImage: UIImage(data: tutor.image!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, maxHeight: 200)
                    .padding()
            }
            VStack (alignment: .leading) {
                HStack {
                    Text(tutor.name).bold().font(.title)
                    Spacer()
                    Image(systemName: "circle.fill").foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    Text(tutor.status == .online ? "Available" : "Unavailable")
                }
                HStack {
                    Text("Rating: ").bold()
                    Text(tutor.rating == 0 ? "--/5.0" : String(format: "%.1f/5.0", tutor.rating)).foregroundStyle(Color.gray)
                }
                HStack {
                    Text("Price: ").bold()
                    Text(String(format: "$%.2f", tutor.price))
                }

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

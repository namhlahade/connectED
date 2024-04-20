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
        HStack (alignment: .center) {
            if (tutor.image == Data() || tutor.image == nil) {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 65, maxHeight: 65)
                
            }
            else {
                Image(uiImage: UIImage(data: tutor.image!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 65, maxHeight: 65)
            }
            VStack (alignment: .leading) {
                HStack {
                    Text(tutor.name).bold().font(.title)
                    Spacer()
                    Image(systemName: "circle.fill").foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    Text(tutor.status.rawValue.capitalized)
                }
                
                Text(tutor.bio ?? "No Bio Info").foregroundStyle(Color.gray)
                
                if tutor.courses.isEmpty == false {
                    Text(getCourselist(courses: tutor.courses))
                }
                else {
                    Text("No courses")
                }
            }
        }
        
    }
}

#Preview {
    let tutor = Tutor.previewData[1]
    return TutorRow(tutor: tutor)
}

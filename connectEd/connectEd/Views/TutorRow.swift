import SwiftUI

struct ParentStruct_TutorRow: View {
    
    var user: Tutor
    @Bindable var tutor: Tutor
    
    
    let getTutorInfoLoader = GetTutorInfoLoader()
    var body: some View {
        VStack {
            switch getTutorInfoLoader.state {
            case .idle: Color.clear
            case .loading: ProgressView()
            case .failed(let error): TutorRow(user: user, tutor: tutor)
            case .success(let tutorInfo):
                TutorRow(user: user, tutor: tutor)
            }
        }
        .task { await getTutorInfoLoader.getTutorInfo(email: EmailStruct(tutorEmail: tutor.email)) }
    }
}

struct TutorRow: View {
    var user: Tutor
    @State var tutor: Tutor
    var body: some View {
        HStack (alignment: .center) {
            if (tutor.image == Data() || tutor.image == nil) {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 65, maxHeight: 65)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(maxWidth: 15, maxHeight: 15)
                            .foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    }
                
                
            }
            else {
                Image(uiImage: UIImage(data: tutor.image!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 65, maxHeight: 65)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(maxWidth: 15, maxHeight: 15)
                            .foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    }
            }
            VStack (alignment: .leading) {
                HStack {
                    Text(tutor.name).bold().font(.title2)
                    Spacer()
                    if user.favorites.contains(tutor.email) {
                        Image(systemName: "star.fill").foregroundStyle(Color.yellow)
                    }
                }.padding([.bottom], -5)
                HStack {
                    Text("Rating: ").bold()
                    Text(tutor.rating == 0 ? "--/5.0" : String(format: "%.1f/5.0", tutor.rating)).foregroundStyle(Color.gray)
                }
                HStack {
                    Text(String(format: "$%.2f / hr", tutor.price))
                }
                
                HStack {
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
}

#Preview {
    let tutor = Tutor.previewData[1]
    return TutorRow(user: Tutor.previewData[0], tutor: tutor)
}

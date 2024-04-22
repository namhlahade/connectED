import SwiftUI
import FirebaseStorage

struct ParentStruct_TutorRow: View {
    
    var user: Tutor
    @Bindable var tutor: Tutor
    
    
    let getTutorInfoLoader = GetTutorInfoLoader()
    var body: some View {
        VStack {
            switch getTutorInfoLoader.state {
            case .idle: Color.clear
            case .loading: ProgressView()
            case .failed(let error): Text("error!")
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
    @State var profilePic: UIImage? = nil
    
    var body: some View {
        HStack (alignment: .center) {
            
            /*if tutor.image != "" {
                Image(uiImage: UIImage(data: Data())!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(maxWidth: 15, maxHeight: 15)
                            .foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    }
                    .frame(maxWidth: 65, maxHeight: 65)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(maxWidth: 15, maxHeight: 15)
                            .foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    }
                    .frame(maxWidth: 65, maxHeight: 65)
            }*/
            
            VStack {
                if tutor.image != "" {
                    if profilePic == nil {
                        ProgressView()
                    }
                    else {
                        Image(uiImage: profilePic!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay(alignment: .bottomTrailing) {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(maxWidth: 15, maxHeight: 15)
                                    .foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                            }
                            .frame(maxWidth: 65, maxHeight: 65)
                    }
                }
                else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(maxWidth: 15, maxHeight: 15)
                                .foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                        }
                        .frame(maxWidth: 65, maxHeight: 65)
                }
            }
            .onAppear {
                if tutor.image != "" {
                    getPhoto(path: tutor.image)
                    print("Getting profile pic on Appear")
                }
            }
            
            
            
            VStack (alignment: .leading) {
                HStack {
                    Text(tutor.name).font(.title2)
                    Spacer()
                    if user.favorites.contains(tutor.email) {
                        Image(systemName: "star.fill").foregroundStyle(Color.yellow)
                    }
                }.padding(.leading, 5)
                HStack {
                    RatingView(rating: $tutor.rating)
                    PriceView(price: $tutor.price)
                }.padding(5)
                
                HStack {
                    if tutor.courses.isEmpty == false {
                        Text(getCourselist(courses: tutor.courses)).foregroundStyle(Color.blue)
                            .padding(5).background(.blue.opacity(0.2))            .cornerRadius(10)
                            .font(.footnote)
                    }
                    else {
                        Text("No courses").foregroundStyle(Color.gray)
                            .padding(5).background(.gray.opacity(0.2))            .cornerRadius(10)
                            .font(.footnote)
                    }
                }.padding([.bottom, .leading, .trailing], 5)
            }
        }
        
    }
    func getPhoto(path: String) {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    // what variable gets updated?
                    profilePic = image
                }
            }
            else {
                print(error)
            }
        }
    }
}

#Preview {
    let tutor = Tutor.previewData[1]
    return TutorRow(user: Tutor.previewData[0], tutor: tutor)
}

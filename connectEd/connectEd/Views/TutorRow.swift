import SwiftUI

struct TutorRow: View {
    var user: Tutor
    @State var tutor: Tutor
    var body: some View {
        HStack (alignment: .center) {
            AsyncImage(url: URL(string: tutor.image), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(maxWidth: 15, maxHeight: 15)
                            .foregroundStyle(tutor.status == .online ? Color.green : Color.red)
                    }
            }, placeholder: {
                if tutor.image != "" {
                    ProgressView()
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
                }
            })
            .frame(maxWidth: 65, maxHeight: 65)
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
}

#Preview {
    let tutor = Tutor.previewData[1]
    return TutorRow(user: Tutor.previewData[0], tutor: tutor)
}

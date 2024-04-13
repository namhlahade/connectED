//
//  Profile.swift
//  connectEd
//
//  Created by Neel Runton on 4/1/24.
//

import SwiftUI


struct Profile: View {
    
    @Bindable var user: Tutor
    
    @State private var isPresentingEditForm: Bool = false
    @State private var editTutorFormData: Tutor.FormData = Tutor.FormData()
    
    
    var body: some View {
        
        ScrollView {
            
            // TODO change this to a SwiftUI saved image
            AsyncImage(url: URL(string: user.image ?? ""), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }, placeholder: {
                if user.image != nil {
                    ProgressView()
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            })
            .frame(maxWidth: 200, maxHeight: 200)
            .padding()
            
            HStack (alignment: .center) {
                Text("My rating:")
                Text(user.rating == nil ? "--/5" : String(format: "%.1f/5", user.rating!)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            
            Spacer()
            Spacer()
            
            VStack(alignment: .leading) {
                
                ProfileSection(title: "Account Information", sectionLabels: ["Name", "Email", "About me"], sectionData: [user.name, user.email, user.bio ?? "No bio entered"])
                
                Spacer()                
                Spacer()
                
                // TODO add dates functionality
                ProfileSection(title: "Tutoring Information", sectionLabels: ["Courses", "Availability", "Price per hour"], sectionData: [getCourselist(courses: user.courses), "Availability here", user.price == nil ? "$0.00" : String(format: "$%.2f", user.price!)])
                
                Spacer()
                Spacer()
                
                Text("My Reviews").font(.title2)
                Spacer()
                if (user.reviews == nil) {
                    Text("You currently have no reviews")
                }
                else {
                    List(user.reviews!) { review in
                        ReviewRow(review: review)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    editTutorFormData = user.dataForForm
                    isPresentingEditForm.toggle()
                }
            }
        }
        .sheet(isPresented: $isPresentingEditForm) {
            NavigationStack {
                ProfileForm(data: $editTutorFormData)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                isPresentingEditForm.toggle()
                            }
                            
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Edit Profile").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                Tutor.update(user, from: editTutorFormData)
                                isPresentingEditForm.toggle()
                            }
                        }
                    }
            }
        }
    }
}

func getCourselist(courses: [Course]) -> String {
    if courses.count == 0 {
        return "No courses entered"
    }
    var courseList: String = ""
    for i in courses {
        courseList.append("\(i.subject.rawValue.uppercased()) \(i.code), ")
    }
    return String(courseList.prefix(courseList.count - 2))
}

struct ProfileSection: View {
    
    var title: String
    var sectionLabels: [String]
    var sectionData: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(title).font(.title2)
            
            Spacer()
            
            ForEach(sectionLabels.indices) { i in
                Text(sectionLabels[i]).font(.title3).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(sectionData[i])
                Spacer()
            }
            
        }
    }
}


#Preview {
    NavigationStack {
        Profile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [Course(subject: .ece, code: "110")], status: .online, isFavorite: false))
    }
}

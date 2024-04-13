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
        
        Form {
            
            // TODO: change this to a SwiftUI saved image
            VStack (alignment: .center) {
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
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            
            
            
            ProfileSection(title: "Account Information", sectionLabels: ["Name", "Email", "About me"], sectionData: [user.name, user.email, user.bio ?? "No bio entered"])
            
            
            ProfileSection(title: "Tutoring Information", sectionLabels: ["Courses", "Availability", "Price per hour"], sectionData: [getCourselist(courses: user.courses), printAvailability(days: user.availability_days, times: user.availability_times), user.price == nil ? "$0.00" : String(format: "$%.2f", user.price!)])
            
            
            Section(header: Text("My Reviews")) {
                if (user.reviews == nil) {
                    Text("You currently have no reviews")
                }
                else {
                    List(user.reviews!) { review in
                        // TODO: do review row
                        ReviewRow(review: review)
                    }
                }
            }
            
            
        }
        .navigationTitle("My Profile")
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

func printAvailability(days: [Tutor.Days], times: [[Date]]) -> String {
    if days.count == 0 {
        return "No availability entered"
    }
    
    var ret: String = ""
    
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    
    for (index, element) in days.enumerated() {
        ret.append("\(days[index].rawValue.capitalized(with: nil)) \(formatter.string(from: times[index][0])) - \(formatter.string(from: times[index][1]))\n")
    }
    
    return String(ret.prefix(ret.count - 1))
}

struct ProfileSection: View {
    
    var title: String
    var sectionLabels: [String]
    var sectionData: [String]
    
    var body: some View {
        Section(header: Text(title)) {
            ForEach(sectionLabels.indices) { i in
                VStack(alignment: .leading) {
                    Text(sectionLabels[i]).font(.title3).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text(sectionData[i])
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        Profile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false, availability_days: [], availability_times: []))
    }
}

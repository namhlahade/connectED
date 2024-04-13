//
//  ProfileForm.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import SwiftUI
import PhotosUI


struct ProfileForm: View {
    
    @State var selectedImage: PhotosPickerItem? = nil
    
    @Binding var data: Tutor.FormData
    
    
    @State private var dates: [[Date]] = [[dateGetter(time: "00:00"), dateGetter(time: "00:00")], [dateGetter(time: "00:00"), dateGetter(time: "00:00")], [dateGetter(time: "00:00"), dateGetter(time: "00:00")], [dateGetter(time: "00:00"), dateGetter(time: "00:00")], [dateGetter(time: "00:00"), dateGetter(time: "00:00")], [dateGetter(time: "00:00"), dateGetter(time: "00:00")], [dateGetter(time: "00:00"), dateGetter(time: "00:00")]]
    
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        
        Form {
            
            // TODO have to get images actually changeable from library
            VStack (alignment: .leading) {
                AsyncImage(url: URL(string: data.image), content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }, placeholder: {
                    if data.image != "" {
                        ProgressView()
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                })
                .overlay(alignment: .bottomTrailing) {
                    PhotosPicker(selection: $selectedImage,
                                 matching: .images) {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 30))
                            .foregroundColor(.accentColor)
                    }
                                 .buttonStyle(.borderless)
                }
                .frame(maxWidth: 200, maxHeight: 200)
                .padding()
            }
            .frame(maxWidth: .infinity)
            
            
            
            TextFieldWithLabel(label: "Name", text: $data.name, prompt: "Enter your name")
            
            TextFieldWithLabel(label: "Email", text: $data.email, prompt: "Enter your email")
            
            VStack(alignment: .leading) {
                Text("About me")
                    .bold()
                    .font(.caption)
                TextEditor(text: $data.bio)
                    .frame(height: 75)
            }
            
            
            VStack(alignment: .leading) {
                Text("Courses")
                    .bold()
                    .font(.caption)
                
                ForEach(Array($data.courses.enumerated()), id: \.offset) { index, element in
                    HStack {
                        
                        Picker("", selection: $data.courses[index].subject) {
                            ForEach(Tutor.Subject.allCases) { subject in
                                Text(subject.rawValue.uppercased())
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        
                        TextField("Class code", text: $data.courses[index].code, prompt: Text("Class code"))
                        
                        Button("", systemImage: "x.circle") {
                            data.courses.remove(at: index)
                        }.buttonStyle(BorderlessButtonStyle())
                        
                    }
                }
                
                Button("Add course", systemImage: "plus.circle") {
                    data.courses.append(Course(subject: .ece, code: "101"))
                }.buttonStyle(BorderlessButtonStyle())
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text("Availability")
                    .bold()
                    .font(.caption)
                
                // TODO: get this working with form data
                ForEach(Array(days.enumerated()), id: \.offset) { index, element in
                    
                    HStack {
                        
                        DatePicker(days[index], selection: $dates[index][0], displayedComponents: [.hourAndMinute])
                        
                        Text("-")
                        
                        DatePicker("", selection: $dates[index][1], displayedComponents: [.hourAndMinute]).labelsHidden()
                    }
                    
                }
                
                
            }
            
            VStack(alignment: .leading) {
                Text("Price per hour")
                    .modifier(FormLabel())
                HStack {
                    Text("$")
                    TextField("Price per hour", value: $data.price, formatter: NumberFormatter(), prompt: Text("Enter your hourly rate")).keyboardType(.decimalPad)
                }.padding(.bottom, 20)
            }
        }
    }
}

func dateGetter(time: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.date(from: time)!
}

#Preview {
    /*let data = Binding.constant(Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false).dataForForm)
     return ProfileForm(data: data)*/
    NavigationStack {
        //Profile(user: Tutor(name: "Neel Runton", email: "ndr19@duke.edu", courses: ["ECE110", "ECE230", "ECE280", "ECE270", "ECE532", "ECE539", "ECE575", "ECE572", "ECE350", "ECE331"], image: "https://education-jrp.s3.amazonaws.com/MovieImages/EverythingEverywhereAllAtOnce.jpg"), status: .online, rating: 3.61, price: 23.99))
        Profile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false, availability: [:]))
    }
}

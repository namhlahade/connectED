//
//  ProfileForm.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage


struct ProfileForm: View {
    
    
    @State var selectedImage: PhotosPickerItem?
    
    
    @Binding var data: Tutor.FormData
    
    @State var profilePic: UIImage? = nil
    
    var body: some View {
        
        Form {
            
            VStack (alignment: .leading) {
                // if ImageData is not nil/empty (have already selected a photo), then display what is in ImageData
                if data.imageData != Data() && data.imageData != nil {
                    Image(uiImage: UIImage(data: data.imageData!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(alignment: .bottomTrailing) {
                            PhotosPicker(selection: $selectedImage,
                                         matching: .images) {
                                Image(systemName: "pencil.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                                    .font(.system(size: 30))
                                    .foregroundColor(.accentColor)
                            }
                                         .buttonStyle(.borderless)
                                         .onChange(of: selectedImage) {
                                             if let newItem = selectedImage {
                                                 loadPhoto(item: newItem)
                                             }
                                         }
                        }
                        .frame(maxWidth: 200, maxHeight: 200)
                        .padding()
                } else {
                    // Else: user hasn't selected a photo already, display their chosen profile picture (or the default person.circle if they have no profile pic [data.image == ""])
                    if data.image != "" {
                        if profilePic == nil {
                            ProgressView()
                        }
                        else {
                            Image(uiImage: profilePic!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .overlay(alignment: .bottomTrailing) {
                                    PhotosPicker(selection: $selectedImage,
                                                 matching: .images) {
                                        Image(systemName: "pencil.circle.fill")
                                            .symbolRenderingMode(.multicolor)
                                            .font(.system(size: 30))
                                            .foregroundColor(.accentColor)
                                    }
                                                 .buttonStyle(.borderless)
                                                 .onChange(of: selectedImage) {
                                                     if let newItem = selectedImage {
                                                         loadPhoto(item: newItem)
                                                     }
                                                 }
                                }
                                .frame(maxWidth: 200, maxHeight: 200)
                                .padding()
                        }
                    }
                    else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay(alignment: .bottomTrailing) {
                                PhotosPicker(selection: $selectedImage,
                                             matching: .images) {
                                    Image(systemName: "pencil.circle.fill")
                                        .symbolRenderingMode(.multicolor)
                                        .font(.system(size: 30))
                                        .foregroundColor(.accentColor)
                                }
                                             .buttonStyle(.borderless)
                                             .onChange(of: selectedImage) {
                                                 if let newItem = selectedImage {
                                                     loadPhoto(item: newItem)
                                                 }
                                             }
                            }
                            .frame(maxWidth: 200, maxHeight: 200)
                            .padding()
                    }
             
                   
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                if data.image != "" {
                    getPhoto(path: data.image)
                    print("Getting profile pic on Appear")
                }
            }
            
            
            
            TextFieldWithLabelAlt(label: "Name", text: $data.name, prompt: "Enter your name")
            
            VStack(alignment: .leading) {
                Text("Email")
                    .bold()
                    .font(.caption)
                    .padding(.bottom, 1)
                Text(data.email).padding(.bottom, 20).foregroundStyle(.gray)
            }
            
            
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
                    HStack (alignment: .center) {
                        
                        Picker("", selection: $data.courses[index].subject) {
                            ForEach(Tutor.Subject.allCases) { subject in
                                Text(subject.rawValue.uppercased())
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        
                        TextField("Class code", text: $data.courses[index].code, prompt: Text("Class code"))
                        
                        Button("", systemImage: "minus.circle.fill") {
                            data.courses.remove(at: index)
                        }.buttonStyle(BorderlessButtonStyle()).foregroundStyle(Color.red)
                        
                    }
                }
                
                Button(action: {
                    data.courses.append(Course(subject: .ece, code: "101"))
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                        Text("Add course")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text("Availability")
                    .bold()
                    .font(.caption)
                
                ForEach(Array($data.selectedHours.enumerated()), id: \.offset) { index, element in
                    HStack {
                        VStack (alignment: .leading) {
                            Picker("", selection: $data.availability[index].day) {
                                ForEach(Availability.Day.allCases) { day in
                                    Text(day.rawValue.capitalized(with: nil))
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .padding([.bottom], -15)
                            
                            HStack {
                                Picker(selection: $data.selectedHours[index][0], label: Text("Select Hour")) {
                                    ForEach(1...12, id: \.self) { hour in
                                        Text("\(hour)").tag(hour)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.wheel)
                                .frame(width: 50, height: 85)
                                .padding([.trailing], -15)
                                
                                Picker(selection: $data.areAM[index][0], label: Text("")) {
                                    Text("AM").tag(true)
                                    Text("PM").tag(false)
                                }
                                .labelsHidden()
                                .pickerStyle(.wheel)
                                .frame(width: 60, height: 85)
                                .padding([.trailing], -15)
                                
                                Text("-")
                                
                                Picker(selection: $data.selectedHours[index][1], label: Text("Select Hour")) {
                                    ForEach(1...12, id: \.self) { hour in
                                        Text("\(hour)").tag(hour)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.wheel)
                                .frame(width: 50, height: 85)
                                .padding([.trailing, .leading], -15)
                                
                                Picker(selection: $data.areAM[index][1], label: Text("")) {
                                    Text("AM").tag(true)
                                    Text("PM").tag(false)
                                }
                                .labelsHidden()
                                .pickerStyle(.wheel)
                                .frame(width: 60, height: 85)
                                
                                
                            }
                        }
                        
                        Spacer()
                        
                        Button("", systemImage: "minus.circle.fill") {
                            data.availability.remove(at: index)
                            data.selectedHours.remove(at: index)
                            data.areAM.remove(at: index)
                        }.buttonStyle(BorderlessButtonStyle())
                            .foregroundStyle(Color.red)
                        
                    }
                    
                }
                
                Button(action: {
                    data.availability.append(Availability(day: .sunday, times: [dateGetter("00:00"), dateGetter("00:00")]))
                    data.selectedHours.append([6, 6])
                    data.areAM.append([true, true])
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                        Text("Add availability")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                
                
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
    
    private func loadPhoto(item: PhotosPickerItem) {
        // Request the image data
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let success_data):
                if let data_ = success_data {
                    // Update the image data to be displayed
                    data.imageData = data_
                } else {
                    // Handle the case where no image data is found
                    print("Failed to load image data.")
                }
            case .failure(let error):
                // Handle errors
                print("Error loading image: \(error.localizedDescription)")
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


func editTime(selectedHour: Int, isAM: Bool) -> Date {
    if selectedHour != 12 {
        return dateGetter("\(selectedHour + (isAM ? 0 : 12)):00")
    }
    return dateGetter("\(isAM ? 0 : 12):00")
}


func dateGetter(_ time: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.date(from: time)!
}

func stringDateGetter(_ time: Date) -> String {
    // Static instance of DateFormatter to improve performance
    struct Static {
        static let formatter: DateFormatter = {
            let fmt = DateFormatter()
            fmt.dateFormat = "HH:mm"
            fmt.locale = Locale(identifier: "en_US_POSIX") // Use a POSIX locale for fixed formats
            fmt.timeZone = TimeZone(identifier: "America/New_York") // Optional: Set to GMT or another specific timezone if needed
            return fmt
        }()
    }
    
    return Static.formatter.string(from: time)
}

struct ProfileForm_Previews: PreviewProvider {
    @State static var loggedIn = true
    @State var count = 0
    @State static var profilePic: UIImage? = nil
    /*let data = Binding.constant(Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false).dataForForm)
     return ProfileForm(data: data)*/
    static var previews: some View {
        NavigationStack {
            //            Profile(user: Tutor(name: "Neel Runton", email: "ndr19@duke.edu", courses: ["ECE110", "ECE230", "ECE280", "ECE270", "ECE532", "ECE539", "ECE575", "ECE572", "ECE350", "ECE331"], image: "https://education-jrp.s3.amazonaws.com/MovieImages/EverythingEverywhereAllAtOnce.jpg"), status: .online, rating: 3.61, price: 23.99))
            UserProfile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, price: 0, reviews: [], favorites: [], availability: []), loggedIn: $loggedIn)
        }
        
    }
}

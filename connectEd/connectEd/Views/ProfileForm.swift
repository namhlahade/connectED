//
//  ProfileForm.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import SwiftUI
import PhotosUI


struct ProfileForm: View {
    
    
    @State var selectedImage: PhotosPickerItem?
    @State private var imageData: Data? = nil
    
    
    @Binding var data: Tutor.FormData
    
    var body: some View {
        
        Form {
            
            VStack (alignment: .leading) {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
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
                    if data.image == Data() {
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
                    } else {
                        Image(uiImage: UIImage(data: data.image)!)
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
                        }.buttonStyle(BorderlessButtonStyle()).foregroundStyle(Color.red)
                        
                    }
                }
                
                Button("Add course", systemImage: "plus.circle") {
                    data.courses.append(Course(subject: .ece, code: "101"))
                }.buttonStyle(BorderlessButtonStyle())
                //.foregroundStyle(Color.green)
                
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
                        
                        Button("", systemImage: "x.circle") {
                            data.availability.remove(at: index)
                            data.selectedHours.remove(at: index)
                            data.areAM.remove(at: index)
                        }.buttonStyle(BorderlessButtonStyle())
                        
                    }
                    
                }
                
                Button("Add availability", systemImage: "plus.circle") {
                    data.availability.append(Availability(day: .sunday, times: [dateGetter("00:00"), dateGetter("00:00")]))
                    data.selectedHours.append([6, 6])
                    data.areAM.append([true, true])
                    
                }.buttonStyle(BorderlessButtonStyle())
                //.foregroundStyle(Color.green)
                
                
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
            case .success(let data):
                if let data = data {
                    // Update the image data to be displayed
                    imageData = data
                    self.data.image = data
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
}

func editTime(selectedHour: Int, isAM: Bool) -> Date {
    if selectedHour != 12 {
        //print("\(selectedHour + (isAM ? 0 : 12)):00")
        return dateGetter("\(selectedHour + (isAM ? 0 : 12)):00")
    }
    //print("\(isAM ? 0 : 12):00")
    return dateGetter("\(isAM ? 0 : 12):00")
}


func dateGetter(_ time: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.date(from: time)!
}

struct ProfileForm_Previews: PreviewProvider {
    @State static var isLoggedOut = false
    /*let data = Binding.constant(Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, isFavorite: false).dataForForm)
     return ProfileForm(data: data)*/
    static var previews: some View {
        NavigationStack {
            //Profile(user: Tutor(name: "Neel Runton", email: "ndr19@duke.edu", courses: ["ECE110", "ECE230", "ECE280", "ECE270", "ECE532", "ECE539", "ECE575", "ECE572", "ECE350", "ECE331"], image: "https://education-jrp.s3.amazonaws.com/MovieImages/EverythingEverywhereAllAtOnce.jpg"), status: .online, rating: 3.61, price: 23.99))
            UserProfile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, price: 0, reviews: [], favorites: [], availability: []), loggedOut: $isLoggedOut)
        }
        
    }
}







/*
 
 if let imageData = imageData, let uiImage = UIImage(data: imageData) {
 Image(uiImage: uiImage)
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
 if data.image == Data() {
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
 } else {
 Image(uiImage: UIImage(data: data.image)!)
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
 }
 }
 
 
 
 */

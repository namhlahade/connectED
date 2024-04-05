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
                
                HStack {
                    Picker("", selection: $data.courses) {
                        ForEach(Tutor.Subject.allCases) { subject in
                                Text(subject.rawValue.uppercased())
                        }
                    }
                    .pickerStyle(.menu)
                    
                    TextField("Class code", value: $data.price, formatter: NumberFormatter(), prompt: Text("Class code"))
                    
                    // TODO have to figure out a way to make this viable for a variable number of courses
                }
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading) {
                Text("Availability")
                    .bold()
                    .font(.caption)
                HStack {
                    Text("Sunday")
                    // TODO add times here
                }
                HStack {
                    Text("Monday")
                    // TODO add times here
                }
                HStack {
                    Text("Tuesday")
                    // TODO add times here
                }
                HStack {
                    Text("Wednesday")
                    // TODO add times here
                }
                HStack {
                    Text("Thursday")
                    // TODO add times here
                }
                HStack {
                    Text("Friday")
                    // TODO add times here
                }
                HStack {
                    Text("Saturday")
                    // TODO add times here
                }
            }
            
            // TODO fix price so only number keyboard is available
            //TextFieldWithLabel(label: "Price per hour", text: $data.price, prompt: "Enter your hourly rate")
            VStack(alignment: .leading) {
                Text("Price per hour")
                    .modifier(FormLabel())
                TextField("Price per hour", value: $data.price, formatter: NumberFormatter(), prompt: Text("Enter your hourly rate"))
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    let data = Binding.constant(Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", status: .online).dataForForm)
    return ProfileForm(data: data)
}

//
//  ProfileForm.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import SwiftUI

struct ProfileForm: View {
    //@Binding var data: Movie.FormData
    @Binding var name: String
    @Binding var email: String
    
    var body: some View {
        Form {
            // TODO get profile picture editing working with PhotoKit
            TextFieldWithLabel(label: "Name", text: $name, prompt: "Enter your name")
            TextFieldWithLabel(label: "Email", text: $email, prompt: "Enter your email")
            /*Picker(selection: $data.genre, label: Text("Genre")) {
             ForEach(Movie.Genre.allCases) { genre in
             Text(genre.rawValue)
             }
             }
             .pickerStyle(.menu)
             VStack(alignment: .leading) {
             Text("Poster URL")
             .bold()
             .font(.caption)
             TextField("Poster URL", text: $data.posterUrl, prompt: Text("Enter a URL"))
             }
             VStack(alignment: .leading) {
             Text("Synopsis")
             .bold()
             .font(.caption)
             TextEditor(text: $data.synopsis)
             .frame(height: 200)
             }
             TextFieldWithLabel(label: "Directed By", text: $data.directedBy, prompt: "Directed By")*/
        }
    }
}

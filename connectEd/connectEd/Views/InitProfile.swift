//
//  InitProfile.swift
//  connectEd
//
//  Created by Nicholas Steinly on 4/20/24.
//

import Foundation
import SwiftUI

struct InitProfile: View {
    @State var editTutorFormData: Tutor.FormData = Tutor.FormData()
    
    var body: some View {
       ProfileForm(data: $editTutorFormData)
        NavigationLink(destination: TabContainer(tutors: Tutor.previewData)){
            Text("Submit")
        }
    }
}

#Preview {
    NavigationStack {
        InitProfile()
    }
}

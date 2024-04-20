//
//  InitProfile.swift
//  connectEd
//
//  Created by Nicholas Steinly on 4/20/24.
//

import Foundation
import SwiftUI

struct InitProfile: View {
    @Bindable var user: Tutor
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
        InitProfile(user: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, reviews: [Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."), Review(email: "njs40@duke.edu", rating: 2.0, clarity: 1.0, prep: 2.0, review: "Most unenjoyable tutoring session of my life. Would not recommend anyone use him.")], isFavorite: false, availability: []))
    }
}

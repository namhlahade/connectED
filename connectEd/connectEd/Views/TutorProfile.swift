//
//  TutorProfile.swift
//  connectEd
//
//  Created by Nicholas Steinly on 4/18/24.
//

import SwiftUI


struct TutorProfile: View {
    
    @Bindable var tutor: Tutor
    var body: some View {
        UserProfile(user: tutor)
        NavigationLink(destination: TutorBookingScreen(tutor: tutor)) {
            Text("Schedule Session")
        }
    }
    
}


#Preview {
    NavigationStack {
        TutorProfile(tutor: Tutor(id: UUID(), name: "Neel Runton", email: "ndr19@duke.edu", courses: [], status: .online, reviews: [], isFavorite: false, availability: []))
    }
}

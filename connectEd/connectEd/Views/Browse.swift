//
//  Browse.swift
//  connectEd
//
//  Created by Neel Runton on 4/1/24.
//

import SwiftUI

struct Browse: View {
    let tutors: [Tutor]
    var body: some View {
        NavigationStack{
            List(tutors) { tutor in
                NavigationLink(destination: TutorDetails(tutor: tutor)){
                    FavoritesRow(tutor: tutor)
                }
            }
            .navigationTitle("Your Saviors")
            .onAppear {
            }
        }

    }
}

#Preview {
    Browse(tutors: Tutor.previewData)
}

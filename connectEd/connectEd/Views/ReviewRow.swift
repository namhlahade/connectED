//
//  ReviewRow.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import SwiftUI

struct ReviewRow: View {
    
    var review: Review
    
    var body: some View {
        Text("review info will go here to display")
    }
}

#Preview {
    ReviewRow(review: Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."))
}

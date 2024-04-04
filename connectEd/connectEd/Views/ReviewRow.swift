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
        // TODO add list of reviews here when Review datastructure is available
        Text("review info will go here to display")
    }
}

#Preview {
    ReviewRow(review: Review(author: "Nick Steinly", date: Date.now, rating: 4, description: "Sample description for the review."))
}

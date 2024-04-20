//
//  ReviewRow.swift
//  connectEd
//
//  Created by Neel Runton on 4/4/24.
//

import SwiftUI

struct ReviewRow: View {
    
    var review: Review
    
    let starColor = HexStringToColor(hex: "#3498eb").color
    
    var body: some View {
        VStack (alignment: .leading) {
            //Text("Overall: \(Int(review.rating))/5").font(.title3).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Button(action: {
                        review.rating = Double(index)
                    }) {
                        Image(systemName: getStarImageName(for: index, review: review))
                            .foregroundColor(starColor)
                            .font(.system(size: 20))
                    }.buttonStyle(.plain)
                    //Spacer()
                }
            }.padding([.bottom], 5)
            
            Text("Clarity: \(Int(review.clarity))/5   Understanding: \(Int(review.prep))/5").padding([.bottom], 5)
            
            //Text("Comments").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("\"\(review.review)\"")
        }
    }
}

#Preview {
    ReviewRow(review: Review(email: "njs40@duke.edu", rating: 4.0, clarity: 3.0, prep: 3.0, review: "Sample description for the review."))
}

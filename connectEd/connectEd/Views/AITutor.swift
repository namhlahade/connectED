//
//  AITutor.swift
//  connectEd
//
//  Created by Namh Lahade on 4/12/24.
//

import SwiftUI

struct AITutor: View {
    let messages: [Message]
    var body: some View {
        Text("Can't find your tutor? Ask Bob")
    }
}

#Preview {
    AITutor(messages: Message.previewData)
}

//
//  Message.swift
//  connectEd
//
//  Created by Namh Lahade on 4/12/24.
//

import Foundation

struct Message: Hashable {
    var id = UUID()
    var messageContent: String
    var isCurrentUser: Bool
}


extension Message {
    static let previewData: [Message] = [
        Message(messageContent: "This is User generated message", isCurrentUser: true),
        Message(messageContent: "This is AI generated message", isCurrentUser: false),
    ]
}

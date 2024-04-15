//
//  AITutor.swift
//  connectEd
//
//  Created by Namh Lahade on 4/12/24.
//

import SwiftUI

struct MessageCell: View {
    let message: Message
    var body: some View {
        Text(message.messageContent)
                    .padding(10)
                    .foregroundColor(message.isCurrentUser ? Color.white : Color.black)
                    .background(message.isCurrentUser ? Color.purple : Color(UIColor.systemGray6 ))
                    .cornerRadius(10)

    }
}

struct MessageView: View {
    var currentMessage: Message
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if !currentMessage.isCurrentUser {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            } else {
                Spacer()
            }
            MessageCell(message: currentMessage)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct AITutor: View {
    let messages: [Message]
    @State var prompt: String = ""
    var body: some View {
        VStack{
            Text("Can't find your tutor? Ask Cipher")
            Spacer()
            ScrollView{
                ForEach(messages, id: \.self) { message in
                    MessageView(currentMessage: message)
                }
            }
            Spacer()
            TextField(
                "Input Prompt",
                text: $prompt
            ).padding()
        }

    }
}

#Preview {
    AITutor(messages: Message.previewData)
}

//
//  AITutor.swift
//  connectEd
//
//  Created by Namh Lahade on 4/12/24.
//

import SwiftUI
import OpenAI

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
    @State var messages: [Message] = []
    @State var prompt: String = ""
    var body: some View {
        VStack{
            Text("Don't have a Tutor, Ask Cipher")
                            .font(.title2)
                            .padding(20)
                            .bold()
            
            ScrollView{
                ForEach(messages, id: \.self) { message in
                    MessageView(currentMessage: message)
                }
            }
            
            Spacer()
            HStack{
                TextField(
                    "Input Prompt",
                    text: $prompt,
                    axis: .vertical
                ).padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                Button{
                    sendNewMessage(content: prompt)
                    prompt = ""
                } label: {
                    Image(systemName: "paperplane")
                }
            }.padding()
        }

    }
    
    let openAI = OpenAI(apiToken: "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") // Change api token cuz I am using someone else's token
    
    func sendNewMessage(content: String) {
        let userMessage = Message(messageContent: content, isCurrentUser: true)
        messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.messageContent)!
            }),
            model: .gpt3_5Turbo
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return }
                DispatchQueue.main.async {
                    messages.append(Message(messageContent: message, isCurrentUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

#Preview {
    AITutor()
}

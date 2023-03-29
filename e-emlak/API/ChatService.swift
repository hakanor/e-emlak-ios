//
//  ChatService.swift
//  e-emlak
//
//  Created by Hakan Or on 27.03.2023.
//

import Foundation
import FirebaseDatabase

struct ChatUser {
    let firstName: String
    let lastName: String
    let uid: String
}

final class ChatService {
    static let shared = ChatService()
    
    private let database = Database.database().reference()
    
    typealias SendMessageCompletion = (Error?) -> Void

    func sendMessage(currentUserId: String, sellerId: String, text: String, completion: @escaping SendMessageCompletion) {
        let conversationId = "\(currentUserId)_\(sellerId)"
        let messageRef = database.child("conversations").child(conversationId).child("messages").childByAutoId()
        let message = [
            "senderId": currentUserId,
            "receiverId": sellerId,
            "text": text,
            "timestamp":
            [".sv": "timestamp"] // this will use Firebase server time as the timestamp
        ] as [String : Any]
        messageRef.setValue(message) { error, _ in
            completion(error)
        }
    }
    
    func fetchMessages(currentUserId: String, sellerId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        let conversationId = "\(currentUserId)_\(sellerId)"
        print("convo ıd = \(conversationId)")
        let conversationRef = database.child("conversations").child(conversationId).child("messages")
        conversationRef.observe(.value) { snapshot in
            print(snapshot)
            var messages = [Message]()
            for child in snapshot.children {
                print(child)
                if let snapshot = child as? DataSnapshot,
                   let messageData = snapshot.value as? [String: Any] {
                    let messageId = snapshot.key
                    
                    let date = messageData["timestamp"] as? String ?? ""
                    let content = messageData["text"] as? String ?? ""
                    let senderId = messageData["senderId"] as? String ?? ""
                    
                    let sender = Sender(photoURL: URL(string: ""),
                                        senderId: senderId,
                                        displayName: "name")
                    
                    let message = Message(sender: sender,
                                   messageId: messageId,
                                   sentDate: Date(),
                                   kind: .text(content))
                    messages.append(message)
                }
            }
            completion(.success(messages))
        }
    }
    
    
}

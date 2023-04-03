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

struct Conversation {
    let conversationId: String
    let lastMessageText: String
    let timestamp: String
    let userId1: String
    let userId2: String
}


var formatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
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
    
    func sendMessage(with conversationId:String, currentUserId: String, sellerId: String, text: String, completion: @escaping SendMessageCompletion) {
        let conversationId = "\(conversationId)"
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
        let conversationId1 = "\(currentUserId)_\(sellerId)"
        let conversationId2 = "\(sellerId)_\(currentUserId)"
        
        // First, try to fetch the conversation with conversationId1
        let conversationRef1 = self.database.child("conversations").child(conversationId1).child("messages")
        conversationRef1.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // Conversation with conversationId1 exists, so fetch its messages
                var messages = [Message]()
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let messageData = snapshot.value as? [String: Any] {
                        let messageId = snapshot.key
                        var date = Date()
                        if let timestamp = messageData["timestamp"] as? Double {
                            date = Date(timeIntervalSince1970: timestamp/1000)
                        }
                        let content = messageData["text"] as? String ?? ""
                        let senderId = messageData["senderId"] as? String ?? ""
                        let sender = Sender(photoURL: URL(string: ""),
                                            senderId: senderId,
                                            displayName: "name")
                        let message = Message(sender: sender,
                                               messageId: messageId,
                                               sentDate: date,
                                               kind: .text(content))
                        messages.append(message)
                    }
                }
                completion(.success(messages))
            } else {
                // Conversation with conversationId1 does not exist, so try to fetch the conversation with conversationId2
                let conversationRef2 = self.database.child("conversations").child(conversationId2).child("messages")
                conversationRef2.observeSingleEvent(of: .value) { snapshot in
                    if snapshot.exists() {
                        // Conversation with conversationId2 exists, so fetch its messages
                        var messages = [Message]()
                        for child in snapshot.children {
                            if let snapshot = child as? DataSnapshot,
                               let messageData = snapshot.value as? [String: Any] {
                                let messageId = snapshot.key
                                var date = Date()
                                if let timestamp = messageData["timestamp"] as? Double {
                                    date = Date(timeIntervalSince1970: timestamp/1000)
                                }
                                let content = messageData["text"] as? String ?? ""
                                let senderId = messageData["senderId"] as? String ?? ""
                                let sender = Sender(photoURL: URL(string: ""),
                                                    senderId: senderId,
                                                    displayName: "name")
                                let message = Message(sender: sender,
                                                       messageId: messageId,
                                                       sentDate: date,
                                                       kind: .text(content))
                                messages.append(message)
                            }
                        }
                        completion(.success(messages))
                    } else {
                        // Conversation with conversationId2 also does not exist, so return an error
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Conversation does not exist"])
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getConversationId(currentUserId: String, sellerId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let conversationId1 = "\(currentUserId)_\(sellerId)"
        let conversationId2 = "\(sellerId)_\(currentUserId)"
        
        let conversationRef1 = database.child("conversations").child(conversationId1)
        let conversationRef2 = database.child("conversations").child(conversationId2)
        
        conversationRef1.observeSingleEvent(of: .value) { snapshot1 in
            if snapshot1.exists() {
                completion(.success(conversationId1))
            } else {
                conversationRef2.observeSingleEvent(of: .value) { snapshot2 in
                    if snapshot2.exists() {
                        completion(.success(conversationId2))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Conversation does not exist"])
                        completion(.failure(error))
                    }
                } withCancel: { error in
                    completion(.failure(error))
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    func observeConversation(conversationId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        let conversationRef = self.database.child("conversations").child(conversationId).child("messages")
        conversationRef.observe(.value) { snapshot in
            var messages = [Message]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let messageData = snapshot.value as? [String: Any] {
                    let messageId = snapshot.key
                    
                    var date = Date()
                    if let timestamp = messageData["timestamp"] as? Double {
                        date = Date(timeIntervalSince1970: timestamp/1000)
                    }
                    
                    
                    let content = messageData["text"] as? String ?? ""
                    let senderId = messageData["senderId"] as? String ?? ""
                    let sender = Sender(photoURL: URL(string: ""),
                                         senderId: senderId,
                                         displayName: "name")
                    let message = Message(sender: sender,
                                           messageId: messageId,
                                           sentDate: date,
                                           kind: .text(content))
                    messages.append(message)
                }
            }
            completion(.success(messages))
        }
    }
    
    func fetchConversations(uid: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        let conversationsRef = self.database.child("conversations")
        conversationsRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                var conversations = [Conversation]()
                for conversation in snapshot.children {
                    if let conversationSnapshot = conversation as? DataSnapshot {
                        let conversationId = conversationSnapshot.key
                        if conversationId.contains(uid) {
                            let messagesRef = conversationsRef.child(conversationId).child("messages")
                            messagesRef.queryLimited(toLast: 1).observeSingleEvent(of: .value) { messagesSnapshot in
                                if messagesSnapshot.exists(), let lastMessage = messagesSnapshot.children.allObjects.last as? DataSnapshot {
                                    let messageData = lastMessage.value as? [String: Any] ?? [:]
                                    let lastMessageText = messageData["text"] as? String ?? ""
                                    var date = Date()
                                    if let timestamp = messageData["timestamp"] as? Double {
                                        date = Date(timeIntervalSince1970: timestamp/1000)
                                    }
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "HH:mm"
                                    let dateString = dateFormatter.string(from: date)
                                    
                                    
                                    let userIds = conversationId.components(separatedBy: "_")
                                    let userId1 = userIds[0]
                                    let userId2 = userIds[1]
                                    let conversation = Conversation(conversationId: conversationId, lastMessageText: lastMessageText, timestamp: dateString, userId1: userId1, userId2: userId2)
                                    conversations.append(conversation)
                                }
                                if conversations.count == snapshot.childrenCount {
                                    completion(.success(conversations))
                                }
                            }
                        }
                    }
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Conversations do not exist"])
                completion(.failure(error))
            }
        }
    }


}

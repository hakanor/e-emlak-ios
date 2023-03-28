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
    
    public func test(){
        database.child("foo").setValue(["something":true])
    }
}

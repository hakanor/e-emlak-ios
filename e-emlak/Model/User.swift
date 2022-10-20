//
//  User.swift
//  e-emlak
//
//  Created by Hakan Or on 20.10.2022.
//

import Foundation

struct User {
    let name: String
    let surname: String
    let email: String
    let phoneNumber: String
    let imageUrl: String
    let uid: String
    
    init(uid:String, dictionary: [String: AnyObject]){
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.surname = dictionary["surname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}

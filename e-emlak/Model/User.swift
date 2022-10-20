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
    var imageUrl: URL?
    let uid: String
    
    init(uid:String, dictionary: [String: AnyObject]){
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.surname = dictionary["surname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        
        if let imageUrlString = dictionary["imageUrl"] as? String {
            let defaultUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/e-emlak-94aba.appspot.com/o/logo.PNG?alt=media&token=edf0ed7d-5fce-4bd2-a8fa-1d785795cafb")
            self.imageUrl = URL(string: imageUrlString) ?? defaultUrl!
        }
    }
}

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
    let password: String
    let aboutMe : String
    let city : String
    
    init(uid:String, dictionary: [String: AnyObject]){
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.surname = dictionary["surname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.city = dictionary["city"] as? String ?? ""
        self.aboutMe = dictionary["aboutMe"] as? String ?? ""
        
        if let imageUrlString = dictionary["imageUrl"] as? String {
            let defaultUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/e-emlak-94aba.appspot.com/o/avatar.jpg?alt=media&token=0ee27972-fd95-4f7d-bd64-e019049e8ab5")
            self.imageUrl = URL(string: imageUrlString) ?? defaultUrl!
        }
    }
}

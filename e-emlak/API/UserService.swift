//
//  UserService.swift
//  e-emlak
//
//  Created by Hakan Or on 20.10.2022.
//

import Foundation
import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(completion: @escaping(User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument(completion: ) { (snapshot,error) in
//            let datas = snapshot?.data()
            
            guard let datas = snapshot?.data() as? [String: AnyObject] else { return }
//            guard let name = datas!["name"] as? String else { return }
//            guard let surname = datas!["surname"] as? String else { return }
//            guard let phoneNumber = datas!["phoneNumber"] as? String else { return }
//            guard let email = datas!["email"] as? String else { return }
//            guard let imageUrl = datas!["imageUrl"] as? String else { return }
            
            let user = User.init(uid: uid, dictionary: datas)
            completion(user)
        }
        
    }
}

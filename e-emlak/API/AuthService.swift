//
//  AuthService.swift
//  e-emlak
//
//  Created by Hakan Or on 15.10.2022.
//

import Foundation
import Firebase
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
    let name: String
    let surname: String
    let phoneNumber: String
}
struct AuthService {
    static let shared = AuthService()
    
    
    func logUserIn(withEmail email: String, password:String, completion: @escaping(AuthDataResult?,Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion:completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let name = credentials.name
        let surname = credentials.surname
        let phoneNumber = credentials.phoneNumber
        // Creating User
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            let values = [
                "email":email,
                "password":password,
                "name":name,
                "surname":surname,
                "phoneNumber":phoneNumber,
                "uid":uid,
            ] as [String : Any]
            Firestore.firestore().collection("users").document(uid).setData(values, completion: completion)

            print("DEBUG: SUCCESFULLY REGISTERED - AuthService")
        })
    }

}

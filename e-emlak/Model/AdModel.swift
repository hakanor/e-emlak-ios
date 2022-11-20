//
//  AdModel.swift
//  e-emlak
//
//  Created by Hakan Or on 7.11.2022.
//

import Foundation

struct Ad {
    let adId: String
    let uid: String
    let title: String
    let price: String
    let location: String
    let images: [String]
    let estateType: String
    var timestamp: Date!
    
    init (adId: String, dictionary: [String:Any]) {
        self.adId = adId
        self.uid = dictionary["uid"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.price = dictionary["price"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.images = dictionary["images"] as? [String] ?? [""]
        self.estateType = dictionary["estateType"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}

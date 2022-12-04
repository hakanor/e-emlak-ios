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
    var description: String
    var floorNumber: Int
    var numberOfFloors: Int
    var numberOfRooms: Int
    var numberOfBathrooms: Int
    var squareMeter: Int
    var squareMeterNet: Int
    var pricePerSquareMeter: Double
    var latitude: Double
    var longitude: Double
    var parcelNumber: Int
    var blockNumber: Int
    var heating: String
    var ageOfBuilding: Int
    
    init (adId: String, dictionary: [String:Any]) {
        self.adId = adId
        self.uid = dictionary["uid"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.price = dictionary["price"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.images = dictionary["images"] as? [String] ?? [""]
        self.estateType = dictionary["estateType"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.floorNumber = dictionary["floorNumber"] as? Int ?? 0
        self.numberOfFloors = dictionary["numberOfFloors"] as? Int ?? 0
        self.numberOfRooms = dictionary["numberOfRooms"] as? Int ?? 0
        self.numberOfBathrooms = dictionary["numberOfBathrooms"] as? Int ?? 0
        self.squareMeter = Int(dictionary["squareMeter"] as? String ?? "") ?? 0
        self.squareMeterNet = dictionary["squareMeterNet"] as? Int ?? 0
        self.pricePerSquareMeter = dictionary["pricePerSquareMeter"] as? Double ?? 0
        self.latitude = dictionary["latitude"] as? Double ?? 0
        self.longitude = dictionary["longitude"] as? Double ?? 0
        self.parcelNumber = dictionary["parcelNumber"] as? Int ?? 0
        self.blockNumber = dictionary["blockNumber"] as? Int ?? 0
        self.heating = dictionary["heating"] as? String ?? ""
        self.ageOfBuilding = dictionary["ageOfBuilding"] as? Int ?? 0

        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}

//
//  AdService.swift
//  e-emlak
//
//  Created by Hakan Or on 27.10.2022.
//

import Foundation
import Firebase

struct ResidentialCredentials {
    var estateType: String
    var title: String
    var description: String
    var price: String
    var squareMeter: String
    var squareMeterNet: String
    var location: String
    var uid: String
    var numberOfRooms: Int
    var numberOfBathrooms: Int
    var ageOfBuilding: Int
    var floorNumber: Int
    var numberOfFloors : Int
    var heating: String
}

struct LandCredentials {
    var estateType: String
    var title: String
    var description: String
    var price: String
    var pricePerSquareMeter: Double
    var squareMeter: String
    var location: String
    var uid: String
    var blockNumber: Int
    var parcelNumber: Int
}

struct CommercialCredentials {
    var estateType: String
    var title: String
    var description: String
    var price: String
    var squareMeter: String
    var location: String
    var uid: String
    var ageOfBuilding: Int
    var numberOfFloors : Int
    var heating: String
}


struct AdService {
    static let shared = AdService()
    
    func postAd(commercialCredentials: CommercialCredentials, completion: @escaping(Error?) -> Void) {
        let estateType = commercialCredentials.estateType
        let title = commercialCredentials.title
        let description = commercialCredentials.description
        let price = commercialCredentials.price
        let squareMeter = commercialCredentials.squareMeter
        let location = commercialCredentials.location
        let uid = commercialCredentials.uid
        let ageOfBuilding = commercialCredentials.ageOfBuilding
        let numberOfFloors = commercialCredentials.numberOfFloors
        let heating = commercialCredentials.heating
        
        let values = [
            "estateType":estateType,
            "title":title,
            "description":description,
            "price":price,
            "squareMeter":squareMeter,
            "location":location,
            "uid":uid,
            "ageOfBuilding":ageOfBuilding,
            "numberOfFloors":numberOfFloors,
            "heating":heating,
            "date": FieldValue.serverTimestamp()
        ] as [String : Any]
        Firestore.firestore().collection("ads").addDocument(data: values, completion: completion)
    }
    
    func postAd(residentialCredentials: ResidentialCredentials, completion: @escaping(Error?) -> Void) {
        let estateType = residentialCredentials.estateType
        let title = residentialCredentials.title
        let description = residentialCredentials.description
        let price = residentialCredentials.price
        let squareMeter = residentialCredentials.squareMeter
        let squareMeterNet = residentialCredentials.squareMeterNet
        let location = residentialCredentials.location
        let uid = residentialCredentials.uid
        let numberOfRooms = residentialCredentials.numberOfRooms
        let numberOfBathrooms = residentialCredentials.numberOfBathrooms
        let ageOfBuilding = residentialCredentials.ageOfBuilding
        let numberOfFloors = residentialCredentials.numberOfFloors
        let floorNumber = residentialCredentials.floorNumber
        let heating = residentialCredentials.heating
    
        let values = [
            "estateType":estateType,
            "title":title,
            "description":description,
            "price":price,
            "squareMeter":squareMeter,
            "squareMeterNet":squareMeterNet,
            "location":location,
            "uid":uid,
            "numberOfRooms":numberOfRooms,
            "numberOfBathrooms":numberOfBathrooms,
            "ageOfBuilding":ageOfBuilding,
            "numberOfFloors":numberOfFloors,
            "floorNumber":floorNumber,
            "heating":heating,
            "date": FieldValue.serverTimestamp()
        ] as [String : Any]
        Firestore.firestore().collection("ads").addDocument(data: values, completion: completion)
    }
    
    func postAd(landCredentials: LandCredentials, completion: @escaping(Error?) -> Void) {
        let estateType = landCredentials.estateType
        let title = landCredentials.title
        let description = landCredentials.description
        let price = landCredentials.price
        let squareMeter = landCredentials.squareMeter
        let pricePerSquareMeter = landCredentials.pricePerSquareMeter
        let location = landCredentials.location
        let uid = landCredentials.uid
        let blockNumber = landCredentials.blockNumber
        let parcelNumber = landCredentials.parcelNumber

        let values = [
            "estateType":estateType,
            "title":title,
            "description":description,
            "price":price,
            "squareMeter":squareMeter,
            "pricePerSquareMeter":pricePerSquareMeter,
            "location":location,
            "uid":uid,
            "blockNumber":blockNumber,
            "parcelNumber":parcelNumber,

            "date": FieldValue.serverTimestamp()
        ] as [String : Any]
        Firestore.firestore().collection("ads").addDocument(data: values, completion: completion)
    }
}

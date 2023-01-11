//
//  AdService.swift
//  e-emlak
//
//  Created by Hakan Or on 27.10.2022.
//

import Foundation
import Firebase
import MapKit

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
    var latitude: Double
    var longitude: Double
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
    var latitude: Double
    var longitude: Double
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
    var latitude: Double
    var longitude: Double
}


struct AdService {
    static let shared = AdService()
    
    func postAd(commercialCredentials: CommercialCredentials, images: [Data], completion: @escaping(Error?) -> Void) {
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
        let latitude = commercialCredentials.latitude
        let longitude = commercialCredentials.longitude
        
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
            "latitude":latitude,
            "longitude":longitude,
            "status":true,
            "date": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        let uuid = UUID().uuidString
        FirFile.shared.startUploading(images: images, id: uuid)
        Firestore.firestore().collection("ads").document(uuid).setData(values,completion: completion)
    }
    
    func postAd(residentialCredentials: ResidentialCredentials, images: [Data], completion: @escaping(Error?) -> Void) {
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
        let latitude = residentialCredentials.latitude
        let longitude = residentialCredentials.longitude
    
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
            "latitude":latitude,
            "longitude":longitude,
            "status":true,
            "date": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        let uuid = UUID().uuidString
        //Firestore.firestore().collection("ads").addDocument(data: values, completion: completion)
        FirFile.shared.startUploading(images: images, id: uuid)
        Firestore.firestore().collection("ads").document(uuid).setData(values,completion: completion)
        
    }
    
    func postAd(landCredentials: LandCredentials, images: [Data], completion: @escaping(Error?) -> Void) {
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
        let latitude = landCredentials.latitude
        let longitude = landCredentials.longitude

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
            "latitude":latitude,
            "longitude":longitude,
            "status":true,
            "date": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        let uuid = UUID().uuidString
        FirFile.shared.startUploading(images: images, id: uuid)
        Firestore.firestore().collection("ads").document(uuid).setData(values,completion: completion)
    }
    
    func fetchAds(completion: @escaping([Ad]) -> Void){
        var ads = [Ad]()
        Firestore.firestore().collection("ads").order(by: "date",descending: true).getDocuments(completion: ) { (snapshot, error)   in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
//                        if let title = document.get("title") as? String {
//                            print(title)
//                        }
                        
                        let timestamp = document.get("date") as? Timestamp
                        // Create Date Formatter
                        let dateFormatter = DateFormatter()
                        // Set Date Format
                        dateFormatter.dateFormat = "dd.MM.YYYY"
                        let formattedDate = dateFormatter.string(from: timestamp?.dateValue() ?? Date())
                        
                        let dictionary = [
                            "adId": documentID,
                            "uid": document.get("uid"),
                            "title": document.get("title"),
                            "price": document.get("price"),
                            "location": document.get("location"),
                            "images": document.get("images"),
                            "estateType": document.get("estateType"),
                            "timestamp": formattedDate,
                            "description": document.get("description"),
                            "floorNumber": document.get("floorNumber"),
                            "numberOfFloors": document.get("numberOfFloors"),
                            "numberOfRooms": document.get("numberOfRooms"),
                            "numberOfBathrooms": document.get("numberOfBathrooms"),
                            "squareMeter": document.get("squareMeter"),
                            "squareMeterNet": document.get("squareMeterNet"),
                            "pricePerSquareMeter": document.get("pricePerSquareMeter"),
                            "latitude": document.get("latitude"),
                            "longitude": document.get("longitude"),
                            "parcelNumber": document.get("parcelNumber"),
                            "blockNumber": document.get("blockNumber"),
                            "heating": document.get("heating"),
                            "ageOfBuilding": document.get("ageOfBuilding"),
                            "status":document.get("status"),
                            
                        ]
                        let status = document.get("status") as? Bool ?? true
                        if status {
                            let ad = Ad(adId: documentID, dictionary: dictionary as [String : Any])
                            ads.append(ad)
                        }
                    }
                    completion(ads)
                }
            }
            
        }
    }
    
    func fetchAds(with Keyword:String, completion: @escaping([Ad]) -> Void){
        var ads = [Ad]()
        
        Firestore.firestore().collection("ads").getDocuments(completion: ) { (snapshot, error)  in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
//                        if let title = document.get("title") as? String {
//                            print(title)
//                        }
                        let timestamp = document.get("date") as? Timestamp
                        // Create Date Formatter
                        let dateFormatter = DateFormatter()
                        // Set Date Format
                        dateFormatter.dateFormat = "dd.MM.YYYY"
                        let formattedDate = dateFormatter.string(from: timestamp?.dateValue() ?? Date())
                        
                        let dictionary = [
                            "adId": documentID,
                            "uid": document.get("uid"),
                            "title": document.get("title"),
                            "price": document.get("price"),
                            "location": document.get("location"),
                            "images": document.get("images"),
                            "estateType": document.get("estateType"),
                            "timestamp": formattedDate,
                            "description": document.get("description"),
                            "floorNumber": document.get("floorNumber"),
                            "numberOfFloors": document.get("numberOfFloors"),
                            "numberOfRooms": document.get("numberOfRooms"),
                            "numberOfBathrooms": document.get("numberOfBathrooms"),
                            "squareMeter": document.get("squareMeter"),
                            "squareMeterNet": document.get("squareMeterNet"),
                            "pricePerSquareMeter": document.get("pricePerSquareMeter"),
                            "latitude": document.get("latitude"),
                            "longitude": document.get("longitude"),
                            "parcelNumber": document.get("parcelNumber"),
                            "blockNumber": document.get("blockNumber"),
                            "heating": document.get("heating"),
                            "ageOfBuilding": document.get("ageOfBuilding"),
                            "status":document.get("status"),
                            
                        ]
                        let string = document.get("location") as! String
                        let status = document.get("status") as? Bool ?? true
                        if string.contains(Keyword) && status == true{
                            let ad = Ad(adId: documentID, dictionary: dictionary as [String : Any])
                            ads.append(ad)
                        }
                    }
                    completion(ads)
                }
            }
            
        }
    }
    
    func fetchAds(withDictionary dictionary: [String:Any], completion: @escaping([Ad]) -> Void){
        var ads = [Ad]()
        
        guard let propertyType = dictionary["propertyType"] else { return }
        guard let numberOfRooms = dictionary["numberOfRooms"] else { return }
        
        guard let priceMin = dictionary["priceMin"] else { return }
        guard let priceMax = dictionary["priceMin"] else{ return }
        
        Firestore.firestore().collection("ads").getDocuments(completion: ) { (snapshot, error)  in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
//                        if let title = document.get("title") as? String {
//                            print(title)
//                        }
                        let dictionary = [
                            "adId": documentID,
                            "uid": document.get("uid"),
                            "title": document.get("title"),
                            "price": document.get("price"),
                            "location": document.get("location"),
                            "images": document.get("images"),
                            "estateType": document.get("estateType"),
                            "timestamp": document.get("date"),
                            "status":document.get("status"),
                        ]
                        
                        let status = document.get("status") as? Bool ?? true
                        
                        let string = document.get("location") as! String
                        if string.contains("Keyword") && status == true {
                            let ad = Ad(adId: documentID, dictionary: dictionary as [String : Any])
                            ads.append(ad)
                        }
                        
                        let price = document.get("price") as! Int
                        if price>(priceMin as! Int) && price<(priceMax as! Int) && status == true {
                            let ad = Ad(adId: documentID, dictionary: dictionary as [String : Any])
                            ads.append(ad)
                        }
                    }
                    completion(ads)
                }
            }
            
        }
    }
    
    func fetchAds(uid:String, completion: @escaping([Ad]) -> Void){
        var ads = [Ad]()
        
        Firestore.firestore().collection("ads").whereField("uid", isEqualTo: uid).order(by: "date",descending: true).getDocuments(completion: ) { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        let timestamp = document.get("date") as? Timestamp
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.YYYY"
                        let formattedDate = dateFormatter.string(from: timestamp?.dateValue() ?? Date())
                        
                        let dictionary = [
                            "adId": documentID,
                            "uid": document.get("uid"),
                            "title": document.get("title"),
                            "price": document.get("price"),
                            "location": document.get("location"),
                            "images": document.get("images"),
                            "estateType": document.get("estateType"),
                            "timestamp": formattedDate,
                            "description": document.get("description"),
                            "floorNumber": document.get("floorNumber"),
                            "numberOfFloors": document.get("numberOfFloors"),
                            "numberOfRooms": document.get("numberOfRooms"),
                            "numberOfBathrooms": document.get("numberOfBathrooms"),
                            "squareMeter": document.get("squareMeter"),
                            "squareMeterNet": document.get("squareMeterNet"),
                            "pricePerSquareMeter": document.get("pricePerSquareMeter"),
                            "latitude": document.get("latitude"),
                            "longitude": document.get("longitude"),
                            "parcelNumber": document.get("parcelNumber"),
                            "blockNumber": document.get("blockNumber"),
                            "heating": document.get("heating"),
                            "ageOfBuilding": document.get("ageOfBuilding"),
                            "status":document.get("status"),
                        ]
                        let status = document.get("status") as? Bool ?? true
                        if status {
                            let ad = Ad(adId: documentID, dictionary: dictionary as [String : Any])
                            ads.append(ad)
                        }
                    }
                    completion(ads)
                }
            }
            
        }
    }
    
    func fetchAllAds(uid:String, completion: @escaping([Ad]) -> Void){
        var ads = [Ad]()
        
        Firestore.firestore().collection("ads").whereField("uid", isEqualTo: uid).order(by: "date",descending: true).getDocuments(completion: ) { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        let timestamp = document.get("date") as? Timestamp
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.YYYY"
                        let formattedDate = dateFormatter.string(from: timestamp?.dateValue() ?? Date())
                        
                        let dictionary = [
                            "adId": documentID,
                            "uid": document.get("uid"),
                            "title": document.get("title"),
                            "price": document.get("price"),
                            "location": document.get("location"),
                            "images": document.get("images"),
                            "estateType": document.get("estateType"),
                            "timestamp": formattedDate,
                            "description": document.get("description"),
                            "floorNumber": document.get("floorNumber"),
                            "numberOfFloors": document.get("numberOfFloors"),
                            "numberOfRooms": document.get("numberOfRooms"),
                            "numberOfBathrooms": document.get("numberOfBathrooms"),
                            "squareMeter": document.get("squareMeter"),
                            "squareMeterNet": document.get("squareMeterNet"),
                            "pricePerSquareMeter": document.get("pricePerSquareMeter"),
                            "latitude": document.get("latitude"),
                            "longitude": document.get("longitude"),
                            "parcelNumber": document.get("parcelNumber"),
                            "blockNumber": document.get("blockNumber"),
                            "heating": document.get("heating"),
                            "ageOfBuilding": document.get("ageOfBuilding"),
                            "status":document.get("status"),
                        ]
                        let ad = Ad(adId: documentID, dictionary: dictionary as [String : Any])
                        ads.append(ad)
                    }
                    completion(ads)
                }
            }
            
        }
    }
    
    func deleteAd(adId:String, completion: @escaping() -> Void){
        Firestore.firestore().collection("ads").document(adId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
            completion()
        }
    }
    
    func updateAd(adId: String, dictionary: [String:Any] , completion: @escaping() -> Void) {
        Firestore.firestore().collection("ads").document(adId).updateData(dictionary) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            completion()
        }
    }
}

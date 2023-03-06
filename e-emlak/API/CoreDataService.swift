//
//  CoreDataService.swift
//  e-emlak
//
//  Created by Hakan Or on 4.03.2023.
//

import Foundation
import UIKit

class CoreDataService{
    public var ads : [AdEntity]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        fetchAdsFromCoreData()
    }
    
    public func fetchAdsFromCoreData(){
        do{
            self.ads = try self.context.fetch(AdEntity.fetchRequest())
        } catch {
            print("Error fetching ads: \(error)")
        }
    }
    
    public func checkObjectExistInCoreData(adId:String) -> Bool{
        fetchAdsFromCoreData()
        for ad in ads ?? [] {
            if(ad.adId == adId){
                return true
            }
        }
        return false
    }
    
    public func saveToCoreData(ad: Ad){
        if (checkObjectExistInCoreData(adId:ad.adId) == false){
            let newAd = AdEntity(context: self.context)
            newAd.adId = ad.adId
            newAd.uid = ad.uid
            newAd.title = ad.title
            newAd.price = ad.price
            newAd.location = ad.location
            newAd.images = ad.images.joined(separator: ",")
            newAd.estateType = ad.estateType
            newAd.timestamp = ad.timestamp
            newAd.adDescription = ad.description
            newAd.floorNumber = Int16(ad.floorNumber)
            newAd.numberOfFloors = Int16(ad.numberOfFloors)
            newAd.numberOfRooms = Int16(ad.numberOfRooms)
            newAd.numberOfBathrooms = Int16(ad.numberOfBathrooms)
            newAd.squareMeter = Int16(ad.squareMeter)
            newAd.squareMeterNet = Int16(ad.squareMeterNet)
            newAd.pricePerSquareMeter = ad.pricePerSquareMeter
            newAd.latitude = ad.latitude
            newAd.longitude = ad.longitude
            newAd.parcelNumber = Int16(ad.parcelNumber)
            newAd.blockNumber = Int16(ad.blockNumber)
            newAd.heating = ad.heating
            newAd.ageOfBuilding = Int16(ad.ageOfBuilding)
            newAd.status = ad.status

            do{
                try self.context.save()
            } catch {
                print("Error saving ad: \(error)")
            }
        }
    }
    
    public func deleteFromCoreData(ad: Ad){
        fetchAdsFromCoreData()
        for adEntity in ads ?? [] {
            if adEntity.adId == ad.adId {
                self.context.delete(adEntity)
                do{
                    try self.context.save()
                } catch {
                    print("Error deleting ad: \(error)")
                }
                break
            }
        }
    }
    
    public func deleteFromCoreData(adEntity : AdEntity){
        self.context.delete(adEntity)
        do{
            try self.context.save()
        } catch {
            print("Error deleting ad: \(error)")
        }
    }
}

//
//  ReportService.swift
//  e-emlak
//
//  Created by Hakan Or on 17.04.2023.
//

import Foundation
import Firebase

struct AdReportCredentials {
    var reportCategory: String
    var adId: String
    var description: String
    var reporterId: String
    var userId: String
}

struct UserReportCredentials {
    var reportCategory: String
    var description: String
    var reporterId: String
    var userId: String
}

struct ReportService {
    static let shared = ReportService()
    
    func postAdReport(adReportCredentials: AdReportCredentials, completion: @escaping(Error?) -> Void) {
        let values = [
            "reportCategory": adReportCredentials.reportCategory,
            "adId": adReportCredentials.adId,
            "description": adReportCredentials.description,
            "reporterId": adReportCredentials.reporterId,
            "userId": adReportCredentials.userId,
            "status": true,
            "date": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        let uuid = UUID().uuidString
        Firestore.firestore().collection("adReports").document(uuid).setData(values,completion: completion)
    }
    
    func postUserReport(userReportCredentials: UserReportCredentials, completion: @escaping(Error?) -> Void) {
        let values = [
            "reportCategory": userReportCredentials.reportCategory,
            "description": userReportCredentials.description,
            "reporterId": userReportCredentials.reporterId,
            "userId": userReportCredentials.userId,
            "status": true,
            "date": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        let uuid = UUID().uuidString
        Firestore.firestore().collection("userReports").document(uuid).setData(values,completion: completion)
    }
}

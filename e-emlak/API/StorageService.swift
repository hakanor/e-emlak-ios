//
//  StorageService.swift
//  e-emlak
//
//  Created by Hakan Or on 4.11.2022.
//

import Foundation
import FirebaseStorage
import Firebase
import UIKit

class FirFile: NSObject {
    
    var urlArray = [String]()

    /// Singleton instance
    static let shared: FirFile = FirFile()

    /// Path
    var kFirFileStorageRef = Storage.storage().reference().child("Files").child("default")
    var id = ""

    /// Current uploading task
    var currentUploadTask: StorageUploadTask?

    func upload(data: Data,
                withName fileName: String,
                block: @escaping (_ url: String?) -> Void) {

        // Create a reference to the file you want to upload
        let fileRef = kFirFileStorageRef.child(fileName)

        /// Start uploading
        upload(data: data, withName: fileName, atPath: fileRef) { (url) in
            block(url)
        }
    }
    
    func upload(data: Data,
                withName fileName: String,
                atPath path:StorageReference,
                block: @escaping (_ url: String?) -> Void) {

        // Upload the file to the path
        self.currentUploadTask = path.putData(data, metadata: nil) { (metaData, error) in
             guard let metadata = metaData else {
                  // Uh-oh, an error occurred!
                  block(nil)
                  return
             }
             // Metadata contains file metadata such as size, content-type.
             // let size = metadata.size
             // You can also access to download URL after upload.
             path.downloadURL { (url, error) in
                  guard let downloadURL = url else {
                     // Uh-oh, an error occurred!
                     block(nil)
                     return
                  }
                 block(url?.absoluteString)
             }
        }
    }

    func cancel() {
        self.currentUploadTask?.cancel()
    }
    
    func startUploading(images: [Data], id: String) {
        self.urlArray.removeAll()
        
        self.kFirFileStorageRef = Storage.storage().reference().child("AdImages").child(id)
        self.id = id
        
         if images.count == 0 {
            return;
         }
        uploadImage(forIndex: 0, images:images)
    }

    func uploadImage(forIndex index:Int, images: [Data]) {

         if index < images.count {
              /// Perform uploading
             let data = images[index]
              let fileName = String(String(index))

              FirFile.shared.upload(data: data, withName: fileName, block: { (url) in
                  /// After successfully uploading call this method again by increment the **index = index + 1**
                  print(url ?? "Couldn't not upload. You can either check the error or just skip this.")
                  self.urlArray.append(url ?? "")
                  
                  Firestore.firestore().collection("ads").document(self.id).updateData(["images":self.urlArray])
                  
                  self.uploadImage(forIndex: index + 1, images:images)
               })
            return;
          }
    }
}

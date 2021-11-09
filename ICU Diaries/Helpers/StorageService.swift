//
//  StorageService.swift
//  ICU Diaries
//
//  Created by jacob kurian on 11/9/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class StorageService {
    static var storage = Storage.storage()
    
    static var storageRoot = storage.reference(forURL: "gs://icu-diaries-e25ff.appspot.com/profilePictures")
    
    static var storageProfile = storageRoot.child("profilePictures")
    
    static func storageProfileId(userId: String) -> StorageReference {
        return storageProfile.child(userId)
    }
//
//    static func saveProfileImage(userId: String, firstName: String, lastName: String, email: String, userType: String, imageData: Data, metaData: StorageMetadata, storageProfileImageRef: StorageReference, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
//
//        storageProfileImageRef.putData(imageData, metadata: metaData) {
//            (StorageMetadata, error) in
//
//            if error != nil {
//                onError(error!.localizedDescription)
//                return
//            }
//
//            storageProfileImageRef.downloadURL(completion: {
//                (url, error) in
//                if let metaImageUrl = url?.absoluteString {
//                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
//                        changeRequest.photoURL = url
////                        let username = firstName + " " + lastName
////                        changeRequest.displayName = username
//                        changeRequest.commitChanges(completion: {
//                            error in
//                            if error != nil {
//                                onError(error!.localizedDescription)
//                                return
//                            }
//                        })
//                    }
//                    let fireStoreUserId = AuthService.getUserId(userId: userId)
//                    var code = NSString("")
//                    if userType == "patient" {
//                        code = randomStringWithLength(len: 6)
//                    }
//                    let user = User(uid: userId, firstName: firstName, lastName: lastName, email: email, userType: userType, profileImageUrl: metaImageUrl)
//                }
//            })
//        }
//
//    }
    
    
}

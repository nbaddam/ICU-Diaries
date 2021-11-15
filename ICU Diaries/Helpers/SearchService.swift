//
//  SearchService.swift
//  ICU Diaries
//
//  Created by jacob kurian on 11/14/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class SearchService {
    
    static func searchPatient(input: String, onSuccess: @escaping (_ patient: [Patient]) -> Void) {
        print("searching for patient")
        let db = Firestore.firestore()
        var docRef: Query = db.collection("users").whereField("userType", isEqualTo: "patient")
        print("got first docref")
        docRef.whereField("searchName", arrayContains: input.lowercased()).getDocuments{
            (querySnapshot, err) in
            print("before guard let")
            guard let snap = querySnapshot else {
                print(err?.localizedDescription)
                return
            }
            
            var patients = [Patient]()
            print("before for loop")
            for document in snap.documents {
                print("inside for loop")
                let dict = document.data()
                let uid = dict["uid"]
                let name = dict["name"]
                let profileImageUrl = dict["profileImageUrl"]
                print(uid, " ", name, " ")
                let patient = Patient(id: uid as! String, name: name as! String, profileImageUrl: profileImageUrl as! String)
                patients.append(patient)
                print("before onSuccess")
                onSuccess(patients)
            }
        }
    }
}

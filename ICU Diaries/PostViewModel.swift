//
//  PostsData.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 11/14/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var db = Firestore.firestore()
   
    func getData() {
        posts.removeAll()
        let doc = Auth.auth().currentUser!.uid
        let docRef = db.collection("users").document(doc)
    
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let testing = document.get("code")
                
                self.db.collection("codes").document(testing as! String).collection("Messages").getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    }
                    else {
                        
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            
                            let id = document.documentID
                            let stamp = data["Time"] as! Timestamp
                            let dateFormatter = DateFormatter()
                            let message = data["Message"] as? String ?? ""
                            let imageName = data["imageUrl"] as? String ?? ""
                            let videoName = data["videoUrl"] as? String ?? ""
                            
                            dateFormatter.dateFormat = "MM/dd/YY 'at' hh:mm aaa"
                            let date = dateFormatter.string(from: stamp.dateValue())
                        
                            
                            let uid = data["UID"] as? String ?? ""
                            
                            // convert UID to userName
                            self.db.collection("users").document(uid).getDocument() { (document, error) in
                                if let document = document {
                                    let fn = document.get("firstName") as? String ?? ""
                                    let ln = document.get("lastName") as? String ?? ""
                                    let type = document.get("userType") as? String ?? ""
                                    let profileImageName = document.get("profileImageUrl") as? String ?? ""
                                    
                                    let post = Post(id: id, userName: fn + " " + ln, dateCreated: date, text: message, profileImageName: profileImageName, imageName: imageName, videoName: videoName)
                                    //if user is family
                                    if type == "friends and family"{
                                        self.posts.append(post)
                                    }
                                    
                                } else {
                                    print("Document does not exist")
                                }
                            }
//                            print("\(document.documentID): \(document.data())")
                            
                        }//prints all documents in the firebase
                    }//else
                }//get documents
            }
        }
    }

}



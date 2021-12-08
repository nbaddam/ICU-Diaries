//
//  MessageViewModel.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 12/06/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MessageViewModel: ObservableObject {
    @Published var messages = [Message]()
    private var db = Firestore.firestore()
    
    func sortData() {
        messages.sorted(by: { $0.time > $1.fileID })
    }
   
    func getData() {
        messages.removeAll()
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
                                    
                                    let type = document.get("userType") as? String ?? ""
                                    
                                    //only continue if user is a clinician
                                    if type == "clinician" {
                                        let name = document.get("name") as? String ?? "username"
                                          
                                        let profileImageName = document.get("profileImageUrl") as? String ?? ""
                                        
                                        let message = Message(id: id, userName: name, dateCreated: date, text: message, profileImageName: profileImageName, imageName: imageName, videoName: videoName)
                                        
                                        self.messages.append(message)
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



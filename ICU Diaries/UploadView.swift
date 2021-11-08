//
//  UploadView.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/27/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UploadView: View {
    @State var message = ""
    var body: some View {
        VStack{
            Text("Message:")
                TextField(
                    "Type Here",
                    text: $message)
                    .disableAutocorrection(true)
                    .cornerRadius(5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
            Text("Upload")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    print("upload clicked")
                    let db = Firestore.firestore()
                    let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let testing = document.get("code")
                            let uid = Auth.auth().currentUser!.uid
                            let add_message = message
                            let time = Timestamp().self
                            db.collection("codes").document(testing as! String).collection("Messages").addDocument(data:
                                                                                                                    ["Message": add_message,
                                                                                                                     "Time": time,
                                                                                                                     "UID": uid])
                            message = ""
                        } else {
                            print("Document does not exist")
                        }
                    }//get document
                }//onTap
        }//Vstack
    }//body
    
}//UploadView

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            
    }
}


/*
let db = Firestore.firestore()
let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
db.collection("codes").document(testing as! String).collection("Messages").getDocuments() { (querySnapshot, error) in
    if let error = error {
        print("Error getting documents: \(error)")
    }
    else {
        for document in querySnapshot!.documents {
//                                        print("\(document.documentID): \(document.data())")
        }//prints all documents in the firebase
    }//else
}//get documents
 
 */

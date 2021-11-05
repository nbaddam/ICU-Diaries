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
                    var uid = ""
                    let user = Auth.auth().currentUser
                    if let user = user {
                        uid = user.uid
                    }
                    //add to firebase
                    //clear textbox
                    print(message)
                    let db = Firestore.firestore()
                    //referece code here, need it to be defined to use
                    let doc_ref = db.collection("codes").document(Auth.auth().currentUser!.code).collection("Messages")
                    doc_ref.getDocuments(){ (querySnapshot, error) in
                        if let error = error {
                                print("Error getting documents: \(error)")
                        } else {
                                for document in querySnapshot!.documents {
                                        print("\(document.documentID): \(document.data())")
                                }
                        }
                    }
                    
                    
                    
                    
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                        "message": message
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }//delete once i figure out adding to messages document
                    
                    message = "" //clear message after upload
                }//onTap
        }//Vstack
    }//body
    
}//UploadView

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            
    }
}

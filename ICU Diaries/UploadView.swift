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
                    //add to firebase
                    //clear textbox
                    print(message)
                    let db = Firestore.firestore()
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                        "message": message
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }//onTap
        }//Vstack
    }//body
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            
    }
}

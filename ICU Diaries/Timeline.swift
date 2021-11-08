//
//  Timeline.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/2/21.
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Timeline: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Timeline")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                Divider()
                
                NavigationLink(destination: FilterView().navigationBarBackButtonHidden(false)) {
                    Text("Filter")
                }
                Divider()
                Spacer()
                GroupBox(
                    label: Label("Mom", systemImage: "heart.fill")
                        .foregroundColor(.red)
                    ) {
                    Text("Can't wait to see you next week!")
                    }.padding()
                
                Spacer()
                Spacer()
            }
        }
    }
}

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        Timeline()
    }
}


/*   Code to read message data for a specific patient
 
 let db = Firestore.firestore()
 let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
 docRef.getDocument { (document, error) in
     if let document = document, document.exists {
         let testing = document.get("code")
         db.collection("codes").document(testing as! String).collection("Messages").getDocuments() { (querySnapshot, error) in
             if let error = error {
                 print("Error getting documents: \(error)")
             }
             else {
                 for document in querySnapshot!.documents {
                     print("\(document.documentID): \(document.data())")
                 }//prints all documents in the firebase
             }//else
         }//get documents
     }
 }
 
 */

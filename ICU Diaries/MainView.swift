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

struct MainView: View {
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            DoctorMessageView()
                .tabItem {
                    Label("Inbox", systemImage: "envelope")
                }
                .tag(0)
            Timeline()
                .tabItem {
                    Label("Timeline", systemImage: "house")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
            UploadView()
                .tabItem {
                    Label("Upload", systemImage: "gear")
                }
                .tag(3)
            //show this only if user == friends and family
        }
    }//body
}//MainView

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


/*
 if(userType() == "patient"){
     TabView(selection: $selection) {
         DoctorMessageView()
             .tabItem {
                 Label("Inbox", systemImage: "envelope")
             }
             .tag(0)
         Timeline()
             .tabItem {
                 Label("Timeline", systemImage: "house")
             }
             .tag(1)
         SettingsView()
             .tabItem {
                 Label("Settings", systemImage: "gear")
             }
             .tag(2)
     }
 }//if
 else if(userType() == "friendsandfamily"){
     TabView(selection: $selection) {
         SettingsView()
             .tabItem {
                 Label("Settings", systemImage: "gear")
             }
             .tag(2)
         UploadView()
             .tabItem {
                 Label("Upload", systemImage: "square.and.pencil")
             }
             .tag(3)
     }
 }//elif
 else{
     TabView(selection: $selection) {
         DoctorMessageView()
             .tabItem {
                 Label("Inbox", systemImage: "envelope")
             }
             .tag(0)
         SettingsView()
             .tabItem {
                 Label("Settings", systemImage: "gear")
             }
             .tag(2)
         UploadView()
             .tabItem {
                 Label("Upload", systemImage: "square.and.pencil")
             }
             .tag(3)
     }
 }//else
 */
/*
 func userType() -> String{
     let db = Firestore.firestore()
     let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
     var testing = ""
     docRef.getDocument { (document, error) in
         if let document = document, document.exists {
             testing = document.get("userType") as! String
         }
     }
     return testing
 }//userType
 */

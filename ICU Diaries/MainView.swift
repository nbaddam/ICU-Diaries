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
    @State var isPatient: Bool
    @State var isFamily: Bool
    @State var isDoctor: Bool
    
    var body: some View {
        if(isPatient == true){
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
                SettingsView(isFamily: false)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(2)
            }
        }//if
        else if(isFamily == true){
            TabView(selection: $selection) {
                SettingsView(isFamily: true)
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
                SettingsView(isFamily: false)
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
    }//body
}//MainView

/*
 struct MainView_Previews: PreviewProvider {
     static var previews: some View {
         MainView()
     }
 }
 */

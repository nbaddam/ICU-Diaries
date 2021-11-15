//
//  ICU_DiariesApp.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/1/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
@main
struct ICU_DiariesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
//            if (Auth.auth().currentUser?.uid == nil) {
                ContentView()
//            }
//            else {
//                let user = Auth.auth().currentUser
//                let db = Firestore.firestore()
//                let userDoc = db.collection("users").document(user!.uid)
//                var userType = ""
//                userDoc.getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        document.data
//                    }
//                }
//            }
        }
    }
}

import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()

    return true
    }
}


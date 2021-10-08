//
//  ICU_DiariesApp.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/1/21.
//

import SwiftUI

@main
struct ICU_DiariesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
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


//
//  Timeline.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/2/21.
//

import SwiftUI

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
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


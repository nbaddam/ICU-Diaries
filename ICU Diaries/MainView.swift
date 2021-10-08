//
//  Timeline.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/2/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DoctorMessageView()
                .tabItem {
                    Label("Inbox", systemImage: "list.dash")
                }
            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage: "home")
                }
            
            SettingsView()
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


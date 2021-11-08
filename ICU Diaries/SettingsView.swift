//
//  SettingsView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/8/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SettingsView: View {
    @State private var SignOutSuccess: Bool? = false
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            Text("oops we're still working on this page!")
            
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), tag: true, selection: $SignOutSuccess) {
                EmptyView()
            }
            Text("Sign Out")
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarHidden(true)
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(8)
                .foregroundColor(.white)
                .onTapGesture {
                    do {
                        try Auth.auth().signOut()
                        SignOutSuccess = true;
                    }
                    catch {
                        print("didnt work try again")
                    }
                }
            
            Spacer()
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

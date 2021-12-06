//
//  AccountCreatedView.swift
//  ICU Diaries
//
//  Created by Janiece Joyner on 11/29/21.
//

import Foundation
import SwiftUI

struct AccountCreatedView : View {
    var userEmail: String
    @State var isOkayClicked: Bool? = false
    
    var body : some View {
        VStack(alignment: .center, spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 64))
                .foregroundColor(Color.white)
                .padding()
                .background(
                        Circle()
                            .fill(Color.green)
                            .frame(width: 90, height: 90)
                    )
            Text("Account Created Successfully!")
                .font(.system(size: 24))
                .fontWeight(.semibold)
            
            NavigationLink(destination: VerificationView(userEmail: userEmail).navigationBarBackButtonHidden(true), tag: true, selection: $isOkayClicked) {
                EmptyView()
            }
            Text("Continue")
                .navigationBarTitle(Text(""), displayMode: .inline)
                .font(.system(size: 20))
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(8)
                .foregroundColor(.white)
                .onTapGesture {
                    print("okay clicked")
                    isOkayClicked = true
                }
        } // VStack
    }
} // AccountCreatedView

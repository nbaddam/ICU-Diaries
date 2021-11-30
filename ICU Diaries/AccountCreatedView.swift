//
//  AccountCreatedView.swift
//  ICU Diaries
//
//  Created by Janiece Joyner on 11/29/21.
//

import Foundation
import SwiftUI

struct AccountCreatedView : View {
    @State var isOkayClicked: Bool? = false
    
    var body : some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Account Created Successfully!")
                .font(.system(size: 24))
                .fontWeight(.semibold)
            Image(systemName: "checkmark.circle")
                .font(.system(size: 64))
                .foregroundColor(Color.green)
            NavigationLink(destination: VerificationView().navigationBarBackButtonHidden(true), tag: true, selection: $isOkayClicked) {
                EmptyView()
            }
            Text("Continue")
                .navigationBarTitle(Text(""), displayMode: .inline)
                .font(.system(size: 20))
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.green)
                .cornerRadius(8)
                .foregroundColor(.white)
                .onTapGesture {
                    print("okay clicked")
                    isOkayClicked = true
                }
        } // VStack
    }
} // AccountCreatedView

struct AccountCreated_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreatedView()
    }
}

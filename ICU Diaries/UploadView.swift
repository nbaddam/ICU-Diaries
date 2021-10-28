//
//  UploadView.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/27/21.
//

import SwiftUI

struct UploadView: View {
    @State var message = ""
    var body: some View {
        VStack{
        Text("Message:")
            TextField(
                "Type Here",
                text: $message)
                .disableAutocorrection(true)
                .cornerRadius(5)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.bottom, 10)
        Text("Upload")
            .padding(10)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .background(Color.blue)
            .cornerRadius(2)
            .foregroundColor(.white)
            .onTapGesture {
                print("sign up clicked")
                //add to firebase
                //clear textbox
            }
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}

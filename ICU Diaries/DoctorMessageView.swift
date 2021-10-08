//
//  DoctorMessageView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/8/21.
//

import SwiftUI

struct DoctorMessageView: View {
    var body: some View {
        VStack {
            Text("Inbox")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            Text("You have no doctor messages at this time :)")
            Spacer()
        }
    }
}

struct DoctorMessageView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorMessageView()
    }
}

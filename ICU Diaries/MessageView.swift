//
//  MessageView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 11/10/21.
//

import SwiftUI
import Foundation
import URLImage
import AVKit

struct Message: Identifiable, Hashable {
    let id: String
    let userName: String
    let dateCreated: String
    let text: String
    let profileImageName: String
    let imageName: String
    let videoName: String
}

struct MessageView: View {
    let message: Message
    let screenWidth: CGFloat
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                if let url = URL(string: message.profileImageName) {
                    URLImage(url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                }
                else{
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                }
                Text(message.userName)
                    .font(.headline)
                Spacer()
                Text(message.dateCreated)
                    .font(.footnote)
            }.padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            
            // only display enough text to fit on one line
            Text(message.text)
                .lineLimit(1)
                .font(.body)
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .padding(.bottom, 16)
                .truncationMode(.tail)
        }
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView()
//    }
//}

//
//  PostView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 11/10/21.
//

import SwiftUI
import Foundation
import URLImage

struct Post: Identifiable, Hashable {
    let id: String
    let userName: String
    let dateCreated: String
    let text: String
    let profileImageName: String
    let imageName: String
}

struct PostView: View {
    let hasImage: Bool
    let hasVideo: Bool
    let hasAudio: Bool
    let post: Post
    let screenWidth: CGFloat
    let defaultProfile = "https://www.google.com/imgres?imgurl=https%3A%2F%2Fcdn.business2community.com%2Fwp-content%2Fuploads%2F2017%2F08%2Fblank-profile-picture-973460_640.png&imgrefurl=https%3A%2F%2Fwww.business2community.com%2Fsocial-media%2Fimportance-profile-picture-career-01899604&tbnid=ZbfgeaptF8Y5ZM&vet=12ahUKEwiZ-Jn7ipn0AhUVQa0KHeBtCUMQMygBegUIARDMAQ..i&docid=Smb2EEjVhvpzWM&w=640&h=640&q=profile%20picture&ved=2ahUKEwiZ-Jn7ipn0AhUVQa0KHeBtCUMQMygBegUIARDMAQ"
    
    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    URLImage(URL(string: post.profileImageName) ?? URL(string: defaultProfile)!) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    }
                    Text(post.userName).font(.headline)
                }.padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                if hasImage {
                    Image(post.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth, height: 250)
                        .clipped()
                }
                Text(post.text)
                    .lineLimit(nil)
                    .font(.system(size: 15))
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                HStack(spacing: 8) {
                    Image(systemName: "heart")
                        .frame(width: 20, height: 20)
                    Spacer()
                    Text(post.dateCreated)
                        .foregroundColor(.gray)
                }.padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
            }.listRowInsets(EdgeInsets())
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView()
//    }
//}

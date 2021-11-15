//
//  PostView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 11/10/21.
//

import SwiftUI
import Foundation
import URLImage
import AVKit

struct Post: Identifiable, Hashable {
    let id: String
    let userName: String
    let dateCreated: String
    let text: String
    let profileImageName: String
    let imageName: String
    let videoName: String
}

struct PostView: View {
    let hasImage: Bool
    let hasVideo: Bool
    let hasAudio: Bool
    let post: Post
    let screenWidth: CGFloat
    
    @State var audioPlayer: AVAudioPlayer!
    @State var videoPlayer: AVPlayer!
    @State var liked = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    if let url = URL(string: post.profileImageName) {
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
                    Text(post.userName).font(.headline)
                }.padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                if hasImage {
                    if let url = URL(string: post.imageName) {
                        URLImage(url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth - 32, height: 250)
                                .clipped()
                        }
                    }
                    else{
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                }
                if hasVideo {
                    if let url = URL(string: post.videoName) {
                        VideoPlayer(player: AVPlayer(url: url))
                            .frame(height: 400)
                    }
                    else {
                        Image(systemName: "play.slash")
                    }
                }
                Text(post.text)
                    .lineLimit(nil)
                    .font(.system(size: 15))
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                HStack(spacing: 8) {
                    Button {
                        print("liked")
                        liked = !liked
                    } label: {
                        Image(systemName: liked ? "heart.fill" : "heart")
                            .frame(width: 20, height: 20)
                    }
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

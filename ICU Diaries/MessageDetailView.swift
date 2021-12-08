//
//  MessageDetailView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 12/7/21.
//

import SwiftUI
import Foundation
import URLImage
import AVKit

struct MessageDetailView: View {
    let hasImage: Bool
    let hasVideo: Bool
    let hasAudio: Bool
    let message: Message
    let screenWidth: CGFloat
    
    @State var audioPlayer: AVAudioPlayer!
    @State var videoPlayer: AVPlayer!
    @State var liked = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(spacing: 8) {
                if let url = URL(string: message.profileImageName) {
                    URLImage(url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    }
                }
                else{
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                }
                Text(message.userName).font(.headline)
                Spacer()
                Text(message.dateCreated)
                    .font(.footnote)
            }.padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            
            Text(message.text)
                .lineLimit(nil)
                .font(.body)
                .padding(16)
            
            if hasImage {
                if let url = URL(string: message.imageName) {
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
                if let url = URL(string: message.videoName) {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(width: screenWidth - 32, height: 400)
                }
                else {
                    Image(systemName: "play.slash")
                }
            }
            Text("[End Message]").font(.body)
            Spacer()

        }.listRowInsets(EdgeInsets())
    }
}

//struct MessageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageDetailView()
//    }
//}

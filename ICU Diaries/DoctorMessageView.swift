//
//  DoctorMessageView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/8/21.
//

import SwiftUI

struct DoctorMessageView: View {
    @ObservedObject private var viewModel = PostViewModel()

     var body: some View {
         VStack {
             Text("Inbox")
                 .font(.largeTitle)
                 .fontWeight(.semibold)
             Spacer()
             GeometryReader { geometry in
                 List {
                     ForEach(viewModel.posts, id: \.id) {(post) in
                         if !post.imageName.isEmpty {
                             PostView(hasImage: true, hasVideo: false, hasAudio: false, post: post, screenWidth: geometry.size.width)
                         }
                         else if !post.videoName.isEmpty {
                             PostView(hasImage: false, hasVideo: true, hasAudio: false, post: post, screenWidth: geometry.size.width)
                         }
                         else {
                             PostView(hasImage: false, hasVideo: false, hasAudio: false, post: post, screenWidth: geometry.size.width)
                         }
                     }
                 }.onAppear() {
                     self.viewModel.posts.removeAll()
                     self.viewModel.getData()
                 }
             }
             NavigationLink(destination: FilterView().navigationBarBackButtonHidden(false)) {
                 Text("Filter")
             }
         }
     }
}

struct PGBS: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}

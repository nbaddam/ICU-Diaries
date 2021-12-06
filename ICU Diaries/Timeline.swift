//
//  Timeline.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/2/21.
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Timeline: View {
    
   @ObservedObject private var viewModel = PostViewModel()

    var body: some View {
        VStack {
            Text("Timeline")
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
//            NavigationLink(destination: FilterView().navigationBarBackButtonHidden(false)) {
//                Text("Filter")
//            }
        }
    }
}

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
    }
}

//struct Timeline_Previews: PreviewProvider {
//    static var previews: some View {
//        Timeline()
//    }
//}


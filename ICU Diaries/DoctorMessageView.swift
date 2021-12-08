//
//  DoctorMessageView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/8/21.
//

import SwiftUI

struct DoctorMessageView: View {
    @ObservedObject private var viewModel = MessageViewModel()

     var body: some View {
         VStack {
             Text("Inbox")
                 .font(.largeTitle)
                 .fontWeight(.semibold)
             Spacer()
             GeometryReader { geometry in
                 List {
                     ForEach(viewModel.messages, id: \.id) {(message) in
                         NavigationLink {
                             if !message.imageName.isEmpty {
                                 MessageDetailView(hasImage: true, hasVideo: false, hasAudio: false, message: message, screenWidth: geometry.size.width)
                             }
                             else if !message.videoName.isEmpty {
                                 MessageDetailView(hasImage: false, hasVideo: true, hasAudio: false, message: message, screenWidth: geometry.size.width)
                             }
                             else {
                                 MessageDetailView(hasImage: false, hasVideo: false, hasAudio: false, message: message, screenWidth: geometry.size.width)
                             }
                            } label: {
                                MessageView(message: message, screenWidth: geometry.size.width)
                            }
                     }
                 }.onAppear() {
                     self.viewModel.messages.removeAll()
                     self.viewModel.getData()
                 }
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

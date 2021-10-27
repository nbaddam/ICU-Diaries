//
//  Timeline.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/2/21.
//

import SwiftUI

struct TimelineView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Timeline")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                Divider()
                
                NavigationLink(destination: FilterView().navigationBarBackButtonHidden(true)) {
                    Text("Filter")
                }
                Divider()
                Spacer()
                GroupBox(
                            label: Label("Mom", systemImage: "heart.fill")
                                .foregroundColor(.red)
                        ) {
                            Text("Can't wait to see you next week!")
                        }.padding()
                GroupBox(
                            label: Label("Dad", systemImage: "book.fill")
                                .foregroundColor(.red)
                        ) {
                            Text("You're doing great!")
                        }.padding()
                GroupBox(
                            label: Label("Amanda", systemImage: "house.fill")
                                .foregroundColor(.red)
                        ) {
                            Text("Miss you so much!")
                        }.padding()
                Spacer()
                Spacer()
            }
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

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}

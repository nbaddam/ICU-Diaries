//
//  Timeline.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/2/21.
//
import SwiftUI

struct Timeline: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Timeline")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                Divider()
                
                NavigationLink(destination: FilterView().navigationBarBackButtonHidden(false)) {
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
        Timeline()
    }
}

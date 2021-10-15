//
//  FilterView.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/10/21.
//

import SwiftUI

struct FilterView: View {
    var body: some View {
        VStack {
            Text("Filter")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
    
            Text("Filter Page")
            Spacer()
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}

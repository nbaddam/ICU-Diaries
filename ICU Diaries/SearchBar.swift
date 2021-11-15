//
//  SearchBar.swift
//  ICU Diaries
//
//  Created by jacob kurian on 11/14/21.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var searchUsers: String
    @State var isSearching = false
    
    var body: some View {
        
        HStack {
            TextField("Select a Patient to Message", text: self.$searchUsers)
                .padding(.leading, 24)
            
        }//.padding()
            .background(Color(.systemGray5))
            .cornerRadius(6.0)
            .padding(.horizontal)
            .onTapGesture(perform: {
                isSearching = true
            })
    }
    
}

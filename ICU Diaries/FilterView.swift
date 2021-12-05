//
//  FilterView.swift
//  ICU Diaries
//
//  Created by Zaher Hage on 10/10/21.
//

import SwiftUI

//idea is have 2 arrays in timeline. One store all the posts in firestore. the other holds only the ones applicable with the filter
//time line will print array 2
//filter will read in the first array and add only the posts that fit the filter and output that as the second array

struct FilterView: View {
    //array of posts
    
    @State private var date = Date()
    
    var body: some View {
        
        DatePicker("Choose Date", selection: $date, in: ...Date(), displayedComponents: .date)
        
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}

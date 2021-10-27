//
//  EyeToggleView.swift
//  ICU Diaries
//
//  Created by Janiece Joyner on 10/27/21.
//

import Foundation
import SwiftUI

struct EyeToggleView: View {
    
    private var imageName: String
    init(name: String) {
        self.imageName = name
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .foregroundColor(.black)
            .frame(width: 22, height: 22, alignment: .trailing)
    }
}

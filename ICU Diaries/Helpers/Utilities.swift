//
//  Utilities.swift
//  ICU Diaries
//
//  Created by Janiece Joyner on 10/7/21.
//

import Foundation
import UIKit
// Class contains text entry validation functions
class Utilities {
    
    // Checks that password minimum 6 charaters, max 15 chars, 1 uppercase, 1 lowercase,
    // 1 number and 1 speacial character
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{6,15}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    // Checks that email is well formed
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

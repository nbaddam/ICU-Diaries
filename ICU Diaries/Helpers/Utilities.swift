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
    // 1 number
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,15}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    // Breaks above function into 4 parts for each requirement
    
    // Check is password contains capital letter
    static func containsCapitalLetter(_ password : String) -> Bool {
        let capitalRegEx = ".*[A-Z]+.*"
        let capitalTest = NSPredicate(format: "SELF MATCHES %@", capitalRegEx)
        return capitalTest.evaluate(with: password)
    }
    
    // Check is password contains lowercase letter
    static func containsLowercaseLetter(_ password : String) -> Bool {
        let lowercaseRegEx = ".*[a-z]+.*"
        let lowercaseTest = NSPredicate(format: "SELF MATCHES %@", lowercaseRegEx)
        return lowercaseTest.evaluate(with: password)
    }
    
    // Check is password contains digit
    static func containsDigit(_ password : String) -> Bool {
        let digitRegEx = ".*[0-9]+.*"
        let digitTest = NSPredicate(format: "SELF MATCHES %@", digitRegEx)
        return digitTest.evaluate(with: password)
    }
    
    // Check is password at least 6 charcaters long
    static func isAtLeastSixCharacters(_ password : String) -> Bool {
        if password.count < 6 {
            return false
        } else {
            return true
        }
    }
    
    // Check password strength
    static func passwordStrength(_ password : String) -> String {
        if isPasswordValid(password) {
            print("Strong password")
            return STRONG_LABEL
        }
        if !isAtLeastSixCharacters(password) {
            print("Password is less than 6 characters")
            return WEAK_LABEL
        }
        if (!containsDigit(password) && !containsCapitalLetter(password)) {
            print("Password does not have digit or uppercase letter")
            return WEAK_LABEL
        }
        if (!containsLowercaseLetter(password) && !containsCapitalLetter(password)) {
            print("Password does not have lowercase letter or uppercase")
            return WEAK_LABEL
        }
        if (!containsLowercaseLetter(password) && !containsDigit(password)) {
            print("Password does not have lowercase or digit")
            return WEAK_LABEL
        }
        else {
            print("Fair password")
            return FAIR_LABEL
        }
        
    }
    
    
    // Checks that email is well formed
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

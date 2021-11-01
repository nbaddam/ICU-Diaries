import Foundation
import SwiftUI

func randomStringWithLength(len: Int) -> NSString {

    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    let randomString : NSMutableString = NSMutableString(capacity: len)

    for _ in 1...len{
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
}

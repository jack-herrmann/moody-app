//
//  Friends.swift
//  Moody?
//
//  Created by Jack Herrmann on 26.02.21.
//

import Foundation

struct Friend: Hashable, Identifiable, Codable {
    
    var name: String
    var currentMood: String = "Ok"
    var premium: Bool = false
    var id: String
    var email: String
    var currentSticker: String = "Lock"
    var fcmToken: String = ""
    var badgeCount: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case name
        case currentMood
        case currentSticker
        case premium
        case id = "uid"
        case email
        case fcmToken
        case badgeCount
    }
    
}

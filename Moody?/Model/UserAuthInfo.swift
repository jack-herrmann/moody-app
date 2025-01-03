//
//  UserAuthInfo.swift
//  Moody?
//
//  Created by Jack Herrmann on 14.07.21.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserAuthInfo {
    
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    
    var isUserAuthenticated: FBAuthState = .undefined
    
    var currentMood: String = "Ok"
    var currentSticker: String = "Lock"
    var uid: String = ""
    var email: String = ""
    var premium: Bool = false
    var friends: [Friend] = [Friend]()
    var receivedRequests: [String] = [String]()
    var sentRequests: [String] = [String]()
    var fcmToken: String = ""
    var badgeCount = 0
    var reactions = [String: String]()
    var reactionsToMe = [String: String]()
    
    mutating func changeMood(mood: String) {
        currentMood = mood
    }
    
    mutating func changeSticker(sticker: String) {
        currentSticker = sticker
    }
    
    mutating func buyPremium() {
        premium = true
    }
    
    mutating func reactTo(id: String, reaction: String) {
        reactions[id] = reaction
    }
    
    mutating func setUid(uid: String) {
        self.uid = uid
    }
    
    mutating func setEmail(email: String) {
        self.email = email
    }
    
    mutating func addFriend(friend: Friend) {
        for fr in friends {
            if fr.name == friend.name {
                removeFriend(friend: fr)
                break
            }
            if fr.id == friend.id {
                removeFriend(friend: fr)
                break
            }
        }
        friends.insert(friend, at: 0)
    }
    
    mutating func removeFriend(friend: Friend) {
        friends.remove(at: friends.firstIndex(of: friend)!)
    }
    
}

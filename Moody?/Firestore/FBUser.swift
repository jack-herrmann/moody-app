//
//  FBUser.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-18.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import Foundation

struct FBUser: Codable, Equatable, Hashable {
    let uid: String
    let email: String
    var currentMood: String
    var currentSticker: String
    var premium: Bool
    let theirFriends: [String]
    var sentRequests: [String]
    var receivedRequests: [String]
    var fcmToken: String
    var badgeCount: Int
    var reactionsToMe: [String]
        
    init(uid: String, email: String, currentMood: String, currentSticker: String, premium: Bool, theirFriends: [String], sentRequests: [String], receivedRequests: [String], fcmToken: String, badgeCount: Int, reactionsToMe: [String]) {
        self.uid = uid
        self.email = email
        self.currentMood = currentMood
        self.currentSticker = currentSticker
        self.premium = premium
        self.theirFriends = theirFriends
        self.sentRequests = sentRequests
        self.receivedRequests = receivedRequests
        self.fcmToken = fcmToken
        self.badgeCount = badgeCount
        self.reactionsToMe = reactionsToMe
    }

}

extension FBUser {
    init?(documentData: [String : Any]) {
        let uid = documentData[FBKeys.User.uid] as? String ?? ""
        let email = documentData[FBKeys.User.email] as? String ?? ""
        let currentMood = documentData[FBKeys.User.currentMood] as? String ?? ""
        let currentSticker = documentData[FBKeys.User.currentSticker] as? String ?? ""
        let premium = documentData[FBKeys.User.premium] as? Bool ?? false
        let theirFriends = documentData[FBKeys.User.theirFriends] as? [String] ?? [String]()
        let sentRequests = documentData[FBKeys.User.sentRequests] as? [String] ?? [String]()
        let receivedRequests = documentData[FBKeys.User.receivedRequests] as? [String] ?? [String]()
        let fcmToken = documentData[FBKeys.User.fcmToken] as? String ?? "" // new
        let badgeCount = documentData[FBKeys.User.badgeCount] as? Int ?? 0
        let reactionsToMe = documentData[FBKeys.User.reactionsToMe] as? [String] ?? [String]()
                
        self.init(uid: uid,
                  email: email,
                  currentMood: currentMood,
                  currentSticker: currentSticker,
                  premium: premium,
                  theirFriends: theirFriends,
                  sentRequests: sentRequests,
                  receivedRequests: receivedRequests,
                  fcmToken: fcmToken,
                  badgeCount: badgeCount,
                  reactionsToMe: reactionsToMe
        )
    }
    
    static func dataDict(uid: String, email: String, currentMood: String, currentSticker: String, premium: Bool, theirFriends: [String], sentRequests: [String], receivedRequests: [String], fcmToken: String, badgeCount: Int, reactionsToMe: [String]) -> [String: Any] {
        var data: [String: Any]
        
            data = [
                FBKeys.User.uid: uid,
                FBKeys.User.email: email,
                FBKeys.User.currentMood: currentMood,
                FBKeys.User.currentSticker: currentSticker,
                FBKeys.User.premium: premium,
                FBKeys.User.theirFriends: theirFriends,
                FBKeys.User.sentRequests: sentRequests,
                FBKeys.User.receivedRequests: receivedRequests,
                FBKeys.User.fcmToken: fcmToken,
                FBKeys.User.badgeCount: badgeCount,
                FBKeys.User.reactionsToMe: reactionsToMe
            ]
        return data
    }
}

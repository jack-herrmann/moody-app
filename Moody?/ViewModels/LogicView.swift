//
//  LogicView.swift
//  Moody?
//
//  Created by Jack Herrmann on 25.02.21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import UserNotifications
import FirebaseMessaging
import WidgetKit


// rework funcs concerning updates
// rework uid pass around

// add one element to database
// test reacting and removing friends
// remove unneccessary functions
// add pulse = false to all modals
// other onAppear func

// tutorial & in-app purchases

class LogicView: ObservableObject {
    
    @Published var userAuthInfo = UserAuthInfo()
    
    var meListener: ListenerRegistration?
    var friendListeners = [String: ListenerRegistration]()
    var currentlyReactingTo = ""
    
    func requestNotificationpermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification(name: String, moodStr: String) {
        let content = UNMutableNotificationContent()
        content.title = "Something"
        content.subtitle = "\(name) now feels like this: \(moodStr)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func getIdViaEmail(email: String, finished: @escaping (String) -> Void) {
        var retId = ""
        Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    retId = document.documentID
                    finished(retId)
                }
            }
        }
    }
    
    // set uid then replace  Auth.auth().
    
    func updateSelf() {
        meListener = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            let newUid = data["uid"] as? String ?? ""
            let newEmail = data["email"] as? String ?? ""
            let fcmToken = data["fcmToken"] as? String ?? ""
            let badgeCount = data["badgeCount"] as? Int ?? 0
            let rR = data["receivedRequests"] as? [String] ?? [String]()
            let sR = data["sentRequests"] as? [String] ?? [String]()
            let newPremium = data["premium"] as? Bool ?? false
            let newCurrentMood = data["currentMood"] as? String ?? ""
            let newCurrentSticker = data["currentSticker"] as? String ?? ""
            let newReactionsToMe = data["reactionsToMe"] as? [String] ?? [String]()
            
            if newUid != self.userAuthInfo.uid {
                self.setUid(uid: newUid)
            }
            
            if newEmail != self.userAuthInfo.email {
                self.setEmail(email: newEmail)
            }
            
            if fcmToken != self.userAuthInfo.fcmToken {
                self.updateFCM()
            }
            
            if badgeCount != self.userAuthInfo.badgeCount {
                self.setBadgeCount(bC: badgeCount)
            }
            if rR != self.userAuthInfo.receivedRequests {
                self.setRR(receivedRequests: rR)
            }
            if sR != self.userAuthInfo.sentRequests {
                self.setSR(sentRequests: sR)
            }
            if newPremium != self.userAuthInfo.premium {
                if newPremium {
                    self.userAuthInfo.buyPremium()
                }
            }
            if newCurrentMood != self.userAuthInfo.currentMood {
                self.userAuthInfo.changeMood(mood: newCurrentMood)
            }
            if newCurrentSticker != self.userAuthInfo.currentSticker {
                self.userAuthInfo.changeSticker(sticker: newCurrentSticker)
            }
            
            for reactions in newReactionsToMe {
                let splitArray = reactions.split(separator: " ")
                self.userAuthInfo.reactionsToMe[String(splitArray[0])] = String(splitArray[1])
            }
            
            let newFriends = data["theirFriends"] as? [String] ?? [String]()
            
            for nF in newFriends {
                let splitArray = nF.split(separator: " ")
                let nFName = String(splitArray[1])
                let nFUid = String(splitArray[0])
                FBFirestore.retrieveFBUser(uid: nFUid) { (result) in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let user):
                        
                        let theirReactions = user.reactionsToMe
                        var newReactions = [String: String]()
                        for reaction in theirReactions {
                            let splitArray2 = reaction.split(separator: " ")
                            if String(splitArray2[0]) == self.userAuthInfo.uid { // Auth.auth...
                                newReactions[nFUid] = String(splitArray2[1])
                            }
                        }
                        self.userAuthInfo.reactions = newReactions
                        
                        let thisFriend = Friend(name: nFName, currentMood: user.currentMood, premium: user.premium, id: nFUid, email: user.email, currentSticker: user.currentSticker, fcmToken: user.fcmToken, badgeCount: user.badgeCount)
                        self.userAuthInfo.addFriend(friend: thisFriend)
                    }
                }
            }
            
        }
    }
    
    func removeSelfListener() {
        meListener?.remove()
    }
    
    func updateFriends() {
        friendListeners = [String: ListenerRegistration]()
        for friend in userAuthInfo.friends {
            let currentFirendListener = Firestore.firestore().collection("users").document(friend.id).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                let newPremium = data["premium"] as? Bool ?? false
                let newCurrentMood = data["currentMood"] as? String ?? ""
                let newCurrentSticker = data["currentSticker"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let fcmToken = data["fcmToken"] as? String ?? ""
                let badgeCount = data["badgeCount"] as? Int ?? 0
                let thisFriend = Friend(name: friend.name, currentMood: newCurrentMood, premium: newPremium, id: friend.id, email: email, currentSticker: newCurrentSticker, fcmToken: fcmToken, badgeCount: badgeCount)
                self.userAuthInfo.addFriend(friend: thisFriend)
                
            }
            friendListeners[friend.id] = currentFirendListener
        }
    }
    
    fileprivate var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange(finished: @escaping () -> Void) {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            guard let _ = user else {
                self.changeAuthenticationState(state: .signedOut)
                return
            }
            self.changeAuthenticationState(state: .signedIn)
            finished()
        })
    }
    
    fileprivate func changeAuthenticationState(state: UserAuthInfo.FBAuthState) {
        userAuthInfo.isUserAuthenticated = state
    }
    
    func logoutSelf() {
        self.resetFCM()
        UIApplication.shared.applicationIconBadgeNumber = 0
        FBAuth.logout { (result) in
            self.setPremium(val: false)
            self.userAuthInfo.changeMood(mood: "Ok")
            self.userAuthInfo.changeSticker(sticker: "Lock")
            self.userAuthInfo.setUid(uid: "")
            self.userAuthInfo.setEmail(email: "")
            self.userAuthInfo.badgeCount = 0
            self.setFriends(friends: [Friend]())
            self.setSR(sentRequests: [String]())
            self.setRR(receivedRequests: [String]())
            self.removeSelfListener()
            for listener in self.friendListeners.values {
                listener.remove()
            }
        }
    }
    
    func chooseMood(mood: String) {
        Firestore.firestore().collection("users").document(userAuthInfo.uid).updateData([ "currentMood": mood ]) // Auth.auth...
        userAuthInfo.changeMood(mood: mood)
        userAuthInfo.reactionsToMe = [String: String]()
        Firestore.firestore().collection("users").document(userAuthInfo.uid).updateData([ "reactionsToMe": [String]() ]) // A...
    }
    
//    func chooseSticker(sticker: String) { // remove
//        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData([ "currentSticker": sticker ])
//        userAuthInfo.changeSticker(sticker: sticker)
//    }
    
    func reactTo(id: String, reaction: String) {
        userAuthInfo.reactTo(id: id, reaction: reaction)
        FBFirestore.retrieveFBUser(uid: id) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                var theirReactions = user.reactionsToMe
                theirReactions.append("\(self.userAuthInfo.uid) \(reaction)") // A...
                Firestore.firestore().collection("users").document(id).updateData([ "reactionsToMe": theirReactions ])
            }
        }
    }
    
    func resetFCM() {
        userAuthInfo.fcmToken = ""
        let usersRef = Firestore.firestore().collection("users").document(userAuthInfo.uid) // A...
        usersRef.setData(["fcmToken": ""], merge: true)
    }
    
    func updateFCM() {
        if let token = Messaging.messaging().fcmToken {
            userAuthInfo.fcmToken = token
            let usersRef = Firestore.firestore().collection("users").document(userAuthInfo.uid) // A...
            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
    
    func buyPremium() {
        Firestore.firestore().collection("users").document(userAuthInfo.uid).updateData([ "premium": true ]) // A...
        userAuthInfo.buyPremium()
    }
    
    func setPremium(val: Bool) {
        userAuthInfo.premium = val
    }
    
    func setUid(uid: String) {
        userAuthInfo.setUid(uid: uid)
    }
    
    func setEmail(email: String) {
        userAuthInfo.setEmail(email: uid)
    }
    
    func setSR(sentRequests: [String]) {
        userAuthInfo.sentRequests = sentRequests
    }
    
    func setRR(receivedRequests: [String]) {
        userAuthInfo.receivedRequests = receivedRequests
    }
    
    func setFriends(friends: [Friend]) {
        userAuthInfo.friends = friends
    }
    
    func setBadgeCount(bC: Int) {
        UIApplication.shared.applicationIconBadgeNumber = bC
        userAuthInfo.badgeCount = bC
        Firestore.firestore().collection("users").document(userAuthInfo.uid).updateData([ "badgeCount": bC ]) // A...
    }
    
    func removeFriend(friend: Friend) {
        userAuthInfo.removeFriend(friend: friend)
        friendListeners[friend.id]!.remove()
        var notation = [String]()
        for fr in userAuthInfo.friends {
            let friendString = "\(fr.id) \(fr.name)"
            notation.append(friendString)
        }
        Firestore.firestore().collection("users").document(userAuthInfo.uid).updateData([ "theirFriends": notation ]) // crash, check value; A...
        FBFirestore.retrieveFBUser(uid: friend.id) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                var theirNameForMe = ""
                for f in user.theirFriends {
                    let splitArr = f.split(separator: " ")
                    if String(splitArr[0]) == self.userAuthInfo.uid { // A...
                        theirNameForMe = String(splitArr[1])
                        break
                    }
                }
                var tF = user.theirFriends
                tF.remove(at: tF.firstIndex(of: "\(self.userAuthInfo.uid) \(theirNameForMe)")!) // A...
                Firestore.firestore().collection("users").document(friend.id).updateData([ "theirFriends": tF ])
            }
        }
    }
    
    func declineRequest(email: String) {
        userAuthInfo.receivedRequests.remove(at: self.receivedRequests.firstIndex(of: email)!)
        Firestore.firestore().collection("users").document(userAuthInfo.uid).updateData([ "receivedRequests": userAuthInfo.receivedRequests ]) // A...
        getIdViaEmail(email: email) { id in
            FBFirestore.retrieveFBUser(uid: id) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    var theirNameForMe = ""
                    for request in user.sentRequests {
                        let splitArr = request.split(separator: " ")
                        if String(splitArr[1]) == self.userAuthInfo.email {
                            theirNameForMe = String(splitArr[0])
                            break
                        }
                    }
                    let theirDeclinedRequest = "\(theirNameForMe) \(self.userAuthInfo.email)"
                    var theirSentRequests = user.sentRequests
                    theirSentRequests.remove(at: theirSentRequests.firstIndex(of: theirDeclinedRequest)!)
                    Firestore.firestore().collection("users").document(id).updateData([ "sentRequests": theirSentRequests ])
                }
            }
        }
    }
    
    func sendRequest(name: String, uid: String, email: String) {
        self.userAuthInfo.sentRequests.append("\(name) \(email)")
        Firestore.firestore().collection("users").document(userAuthInfo.uid).setData([ "sentRequests": self.userAuthInfo.sentRequests], merge: true)
        FBFirestore.retrieveFBUser(uid: uid) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                var theirReceivedRequests = user.receivedRequests
                theirReceivedRequests.append(self.userAuthInfo.email) // A...
                Firestore.firestore().collection("users").document(uid).updateData([ "receivedRequests": theirReceivedRequests ])
            }
            
        }
    }
    
    func acceptRequest(email: String, id: String, givenName: String) {
        print(id)
        FBFirestore.retrieveFBUser(uid: id) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                let newFriend = Friend(name: givenName, currentMood: user.currentMood, premium: user.premium, id: user.uid, email: user.email, currentSticker: user.currentSticker, fcmToken: user.fcmToken, badgeCount: user.badgeCount)
                self.userAuthInfo.addFriend(friend: newFriend)
                print("hello123")
                var myFriends = [String]()
                for friend in self.userAuthInfo.friends {
                    myFriends.append("\(friend.id) \(friend.name)")
                }
                Firestore.firestore().collection("users").document(self.userAuthInfo.uid).updateData([ "theirFriends": myFriends ]) // A...
                var theirNameForMe = ""
                for request in user.sentRequests {
                    let splitArr = request.split(separator: " ")
                    if String(splitArr[1]) == self.userAuthInfo.email { // A...
                        theirNameForMe = String(splitArr[0])
                        break
                    }
                }
                var theirFriends = user.theirFriends
                theirFriends.append("\(self.userAuthInfo.uid) \(theirNameForMe)") // A...
                Firestore.firestore().collection("users").document(id).updateData([ "theirFriends": theirFriends ])
                self.userAuthInfo.receivedRequests.remove(at: self.receivedRequests.firstIndex(of: email)!)
                Firestore.firestore().collection("users").document(self.userAuthInfo.uid).updateData([ "receivedRequests": self.userAuthInfo.receivedRequests ]) // A...
                let theirAcceptedRequest = "\(theirNameForMe) \(self.userAuthInfo.email)" // A...
                var theirSentRequests = user.sentRequests
                theirSentRequests.remove(at: theirSentRequests.firstIndex(of: theirAcceptedRequest)!)
                Firestore.firestore().collection("users").document(id).updateData([ "sentRequests": theirSentRequests ])
            }
        }
        
    }
    
    func sendPushNotificationToAllFriendsForMoodsAndStickers() {
        for f in userAuthInfo.friends {
            var tNFM = ""
            var bC = 0
            FBFirestore.retrieveFBUser(uid: f.id) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    let theirFriends = user.theirFriends
                    bC = user.badgeCount
                    for fr in theirFriends {
                        let splitArray = fr.split(separator: " ")
                        let nFName = String(splitArray[1])
                        let nFUid = String(splitArray[0])
                        if nFUid == self.userAuthInfo.uid { // A...
                            tNFM = nFName
                        }
                    }
                }
                let sender = PushNotificationSender()
                if f.fcmToken != "" {
                    sender.sendPushNotification(to: f.fcmToken, title: "Update", body: "Check how \(tNFM) is feeling!", badgeInfo: bC+1)
                    Firestore.firestore().collection("users").document(f.id).updateData([ "badgeCount": bC+1 ])
                }
            }
        }
    }
    
    func sendPushNotificationForRequest(id: String) {
        var bC = 0
        FBFirestore.retrieveFBUser(uid: id) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                bC = user.badgeCount
                let sender = PushNotificationSender()
                if user.fcmToken != "" {
                    sender.sendPushNotification(to: user.fcmToken, title: "Request", body: "\(self.userAuthInfo.email) wants to be your friend!", badgeInfo: bC+1) // A... ?? ""
                    Firestore.firestore().collection("users").document(id).updateData([ "badgeCount": bC+1 ])
                }
            }
        }
    }
    
    func sendPushNotificationForAcceptedRequest(id: String) {
        var tNFM = ""
        var bC = 0
        FBFirestore.retrieveFBUser(uid: id) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                let theirFriends = user.theirFriends
                bC = user.badgeCount
                for fr in theirFriends {
                    let splitArray = fr.split(separator: " ")
                    let nFName = String(splitArray[1])
                    let nFUid = String(splitArray[0])
                    if nFUid == self.userAuthInfo.uid {
                        tNFM = nFName
                    }
                }
                let sender = PushNotificationSender()
                if user.fcmToken != "" {
                    sender.sendPushNotification(to: user.fcmToken, title: "New Friend", body: "\(tNFM) has accepted your request!", badgeInfo: bC+1)
                    Firestore.firestore().collection("users").document(id).updateData([ "badgeCount": bC+1 ])
                }
            }
        }
    }
    
    func sendPushNotificationForDeclinedRequest(id: String) {
        var bC = 0
        FBFirestore.retrieveFBUser(uid: id) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                bC = user.badgeCount
                let sender = PushNotificationSender()
                if user.fcmToken != "" {
                    sender.sendPushNotification(to: user.fcmToken, title: "No new Friend", body: "\(self.userAuthInfo.email) has declined your request!", badgeInfo: bC+1)
                    Firestore.firestore().collection("users").document(id).updateData([ "badgeCount": bC+1 ])
                }
            }
        }
    }
    
    func sendPushNotificationForReaction(id: String) {
        var bC = 0
        var tNFM = ""
        FBFirestore.retrieveFBUser(uid: id) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                bC = user.badgeCount
                let theirFriends = user.theirFriends
                for fr in theirFriends {
                    let splitArray = fr.split(separator: " ")
                    let nFName = String(splitArray[1])
                    let nFUid = String(splitArray[0])
                    if nFUid == self.userAuthInfo.uid {
                        tNFM = nFName
                    }
                }
                let sender = PushNotificationSender()
                if user.fcmToken != "" {
                    sender.sendPushNotification(to: user.fcmToken, title: "Reaction", body: "\(tNFM) has reacted to you", badgeInfo: bC+1)
                    Firestore.firestore().collection("users").document(id).updateData([ "badgeCount": bC+1 ])
                }
            }
        }
    }
    
    func sendPushNotificationForRemovedFriend(id: String) {
        var bC = 0
        FBFirestore.retrieveFBUser(uid: id) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                bC = user.badgeCount
                let sender = PushNotificationSender()
                if user.fcmToken != "" {
                    sender.sendPushNotification(to: user.fcmToken, title: "Lost Friend", body: "\(self.userAuthInfo.email) has removed you as a friend!", badgeInfo: bC+1)
                    Firestore.firestore().collection("users").document(id).updateData([ "badgeCount": bC+1 ])
                }
            }
        }
    }
    
    var isUserAuthenticated: UserAuthInfo.FBAuthState {
        userAuthInfo.isUserAuthenticated
    }
    
    var currentMood: String {
        userAuthInfo.currentMood
    }
    
//    var currentSticker: String { // remove
//        userAuthInfo.currentSticker
//    }
    
    var reactions: [String: String] {
        userAuthInfo.reactions
    }
    
    var reactionsToMe: [String: String] {
        userAuthInfo.reactionsToMe
    }
    
    var badgeCount: Int {
        userAuthInfo.badgeCount
    }
    
    var premium: Bool {
        userAuthInfo.premium
    }
    
    var uid: String {
        userAuthInfo.uid
    }
    
    var friends: [Friend] {
        userAuthInfo.friends
    }
    
    var sentRequests: [String] {
        userAuthInfo.sentRequests
    }
    
    var receivedRequests: [String] {
        userAuthInfo.receivedRequests
    }
    
    var fcmToken: String {
        userAuthInfo.fcmToken
    }
    
    var email: String {
        userAuthInfo.email
    }
    
}

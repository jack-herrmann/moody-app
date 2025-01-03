//
//  Moody_App.swift
//  Moody?
//
//  Created by Jack Herrmann on 21.02.21.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseMessaging
import FirebaseAnalytics

@main
struct Moody_App: App {
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    @ObservedObject var logicController = LogicController()
    
    //@ObservedObject var logicView = LogicView()
        
    //init() {
        
        //FirebaseApp.configure()

        //let pushManager = PushNotificationManager()
        //pushManager.registerForPushNotifications()

//        logicView.configureFirebaseStateDidChange() { return }
//        logicView.updateSelf()
//        logicView.updateFriends()


        //UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]

        //if #available(iOS 15, *) {
       //     let appearance = UINavigationBarAppearance()
       //     appearance.configureWithOpaqueBackground()
       //     UINavigationBar.appearance().standardAppearance = appearance
       //     UINavigationBar.appearance().scrollEdgeAppearance = appearance
       // }
    //}
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            Main()//.environmentObject(logicController)
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//
//    @ObservedObject var logicView = LogicView()
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//        FirebaseApp.configure()
//
//        let pushManager = PushNotificationManager()
//        pushManager.registerForPushNotifications()
//
//        logicView.configureFirebaseStateDidChange() {
//            self.logicView.updateSelf()
//            self.logicView.updateFriends()
//        }
//
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
//
//        if #available(iOS 15, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        }
//
//        return true
//    }
//
//}

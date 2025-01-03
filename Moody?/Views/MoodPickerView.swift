//
//  BottomSheet.swift
//  Moody?
//
//  Created by Jack Herrmann on 23.02.21.
//
//
//
//import Foundation
//import SwiftUI
//import Combine
//import Firebase
//import FirebaseAuth
//
//struct MoodPickerView: View {
//    @EnvironmentObject var logicView: LogicView
//    @Environment(\.presentationMode) var presentation
//
//    @Binding var set: Bool
//
//    @State var moodSaved: Mood = Constants.moods[0]
//
//    private let columns = [ GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()) ]
//
//    init(set: Binding<Bool>) {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
//        self._set = set
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            self.body(for: geometry.size)
//        }
//        .environmentObject(logicView)
//    }
//
//    private func body (for size: CGSize) -> some View {
//        NavigationView {
//            VStack {
//                ScrollView(showsIndicators: false) {
//                    LazyVGrid(columns: columns, spacing: 10) {
//                        ForEach(Constants.myMoods, id: \.self) { mood in
//                            VStack (spacing: 0) {
//                                Image(mood.img)
//                                    .frame(width: 85, height: 85)
//                                    .shadow(radius: 4)
//                                    .shadow(radius: 2)
//                                    .onTapGesture {
//                                        var cnt = logicView.friends.count
//                                        logicView.chooseMood(mood: mood.name)
//                                        for f in logicView.friends {
//                                            cnt -= 1
//                                            var tNFM = ""
//                                            var bC = 0
//                                            FBFirestore.retrieveFBUser(uid: f.id) { (result) in
//                                                switch result {
//                                                case .failure(let error):
//                                                    print(error.localizedDescription)
//                                                case .success(let user):
//                                                    let theirFriends = user.theirFriends
//                                                    bC = user.badgeCount
//                                                    for fr in theirFriends {
//                                                        let splitArray = fr.split(separator: " ")
//                                                        let nFName = String(splitArray[1])
//                                                        let nFUid = String(splitArray[0])
//                                                        if nFUid == Auth.auth().currentUser!.uid {
//                                                            tNFM = nFName
//                                                        }
//                                                    }
//                                                }
//                                                let sender = PushNotificationSender()
//                                                if f.fcmToken != "" {
//                                                    sender.sendPushNotification(to: f.fcmToken, title: "Update", body: "Check how \(tNFM) is feeling!", badgeInfo: bC+1)
//                                                    Firestore.firestore().collection("users").document(f.id).updateData([ "badgeCount": bC+1 ])
//                                                }
//                                            }
//                                            print("Token: \(f.fcmToken)")
//                                        }
//                                        set = true
//                                        self.presentation.wrappedValue.dismiss()
//                                    }
//                                Text(mood.name)
//                                    .font(.custom("Galvji", size: min(size.width, size.height) *  0.035))
//                                    .padding(10)
//                            }
//                        }
//                    }
//                    .padding(10)
//                }
//            }
//            .foregroundColor(.black)
//            .cornerRadius(15)
//            .background(LinearGradient(gradient: Gradient(colors: [Constants.lightYellowAccent, Constants.lightYellowAccent]), startPoint: .topLeading, endPoint: .bottomTrailing)
//            .edgesIgnoringSafeArea(.all))
//            .navigationBarTitle("Moods")
//            .navigationBarItems(trailing: cancel)
//            .statusBar(hidden: true)
//            .blueNavigation
//        }
//    }
//    var cancel: some View {
//        Button("Cancel") {
//            set = true
//            self.presentation.wrappedValue.dismiss()
//        }
//        .foregroundColor(Constants.goldOutline)
//    }
//
//}

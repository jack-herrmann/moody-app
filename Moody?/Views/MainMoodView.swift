//
//  ContentView.swift
//  Moody?
//
//  Created by Jack Herrmann on 21.02.21.
//

import SwiftUI
import WidgetKit
import Firebase
import FirebaseMessaging

struct MainMoodView: View {
    @AppStorage("topFriendsMoodData", store: UserDefaults(suiteName: "group.de.gmx-herrmann.jack.Moody-"))
    var topFriendsMoodData: Data = Data()
    
    enum modalChoices {
        case moodPicker, stickerPicker, requests, tutorial
    }
    
    @EnvironmentObject var logicView: LogicView
    
    @State var pulse: Bool = false
    
    @State private var currentlyShownReaction = 0
    @State private var showAddFriendAlert = false
    @State private var remFriend = Friend(name: "", id: "", email: "")
    @State private var remove = false
    @State private var showConfirmation = false
    @State private var modalView = modalChoices.moodPicker
    @State private var showModal = false
    @State private var offset: CGFloat = 0
    @State private var set = false
    @State private var sticker = false
    @State private var success = false
    @State private var text = ""
    @State private var text2 = ""
    @State private var contained = false
    @State private var containedAlertIsShown = false
    
    var body: some View {
        GeometryReader { reader in
            if logicView.isUserAuthenticated == .undefined {
                ZStack {
                    Constants.lightYellowAccent
                        .edgesIgnoringSafeArea(.all)
                    Image(systemName: "hourglass")
                        .imageScale(.large)
                        .spinning()
                        .position(x: reader.size.width/2, y: reader.size.height/2)
                        .foregroundColor(.black)
                }
                .statusBar(hidden: true)
            } else if logicView.isUserAuthenticated == .signedOut {
                ActionSheet()
            } else {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Constants.lightYellowAccent, Constants.lightYellowAccent]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Button(action: {
                                pulse = false
                                self.showModal = true
                                modalView = modalChoices.moodPicker
                            }) {
                                Image(systemName: "face.dashed.fill")
                                    .accentColor(Constants.goldOutline)
                                    .font(.custom("Galvji", size: fontSize(for: reader.size)))
                            }
//                            Spacer()
//                            Button(action: {
//                                pulse = false
//                                self.showModal = true
//                                modalView = modalChoices.stickerPicker
//                            }) {
//                                Image(systemName: "sparkles.square.fill.on.square")
//                                    .accentColor(Constants.goldOutline)
//                                    .font(.custom("Galvji", size: fontSize(for: reader.size)))
//                            }
                            Spacer()
                            Button(action: {
                                //pulse false
                                showAddFriendAlert = true
                            }) {
                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                    .accentColor(Constants.goldOutline)
                                    .font(.custom("Galvji", size: fontSize(for: reader.size)))
                            }
                            Spacer()
                            ZStack {
                                Button(action: {
                                    pulse = false
                                    self.showModal = true
                                    modalView = modalChoices.requests
                                    
                                }) {
                                    Image(systemName: "person.crop.circle.fill.badge.questionmark")
                                        .accentColor(Constants.goldOutline)
                                        .font(.custom("Galvji", size: fontSize(for: reader.size)))
                                }
                                if !(logicView.userAuthInfo.receivedRequests.isEmpty) {
                                    Group {
                                        Circle()
                                            .foregroundColor(.red)
                                        Text("\(logicView.userAuthInfo.receivedRequests.count)")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    }
                                    .frame(width: 15, height: 15)
                                    .offset(x: reader.size.width/50, y: -(reader.size.height/100))
                                }
                            }
                            Spacer()
                            Button(action: {
                                pulse = false
                                logicView.logoutSelf()
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .accentColor(Constants.goldOutline)
                                    .font(.custom("Galvji", size: fontSize(for: reader.size)))
                            }
                        }
                        .padding([.leading, .trailing])
                        meInfo(for: reader.size)
                        friendsInfo(for: reader.size)
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showModal = true
                                modalView = modalChoices.tutorial
                            }) {
                                Image(systemName: "info.circle.fill")
                                    .accentColor(Constants.goldOutline)
                                    .font(.custom("Galvji", size: fontSize(for: reader.size)))
                            }
                        }
                    }
                    .onChange(of: logicView.friends) { _ in
                        save(logicView.friends)
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    .onChange(of: set) { _ in
                        if set {
                        }
                        set = false
                    }
                    .onAppear { // do that when app enters background, below
                        save(logicView.friends)
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    .padding([.top, .leading, .trailing])
                    .padding(.bottom, 5)
                    Success(isShown: $success)
                    CustomAlert(isShown: $showAddFriendAlert, text: $text, text2: $text2, title: "Friend request", onDone: { (text, text2) in
                        for friend in logicView.friends {
                            if friend.name == text {
                                contained = true
                            }
                            if friend.email == text2 {
                                contained = true
                            }
                            if logicView.email == text2 {
                                contained = true
                            }
                        }
                        Firestore.firestore().collection("users").whereField("email", isEqualTo: text2).getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                contained = true
                                for _ in querySnapshot!.documents {
                                    contained = false
                                }
                            }
                        }
                        if contained { // change check if possible to other variable and add "or cant" here
                            containedAlertIsShown = true
                        } else {
                            logicView.getIdViaEmail(email: text2) { id in
                                logicView.sendRequest(name: text, uid: id, email: text2)
                                logicView.sendPushNotificationForRequest(id: id)
                            }
                            success = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                success = false
                            }
                        }
                        self.text = ""
                        self.text2 = ""
                    })
                        .alert(isPresented: $containedAlertIsShown) { () -> Alert in
                            Alert(title: Text("Invalid"), message:  Text("Either you have already added a friend with this name or email or this friend hasn't registered yet"), dismissButton: .default(Text("OK")) {
                                containedAlertIsShown = false
                                contained = false
                            })
                        }
                        .statusBar(hidden: true)
                        .fullScreenCover(isPresented: $showModal) { [modalView] in
                            switch modalView {
                            case .moodPicker:
                                MoodView(set: $set, pulse: $pulse).environmentObject(logicView)
                            case .stickerPicker:
                                StickerView(pulse: $pulse).environmentObject(logicView)
                            case .requests:
                                RequestsView(pulse: $pulse).environmentObject(logicView)
                            case .tutorial:
                                TutorialView()
                            }
                        }
                }
            }
        }
        .environmentObject(logicView)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            logicView.setBadgeCount(bC: logicView.receivedRequests.count)
        }
        .onAppear { // remove
            logicView.configureFirebaseStateDidChange() {
                logicView.updateSelf()
                logicView.updateFriends()
//                let pushManager = PushNotificationManager()
//                pushManager.registerForPushNotifications()
            }
        }
    }
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) *  0.0485
    }
    
    private func frameSizeWidth(for size: CGSize) -> CGFloat {
        size.width / 3.5
    }
    
    private func frameSizeHeight(for size: CGSize) -> CGFloat {
        size.height / 6.5
    }
    
    @ViewBuilder
    private func meInfo(for size: CGSize) -> some View {
        VStack {
            HStack {
                ZStack {
                    Image(logicView.currentMood)
                        .resizable()
                        .pulsating(pulse: $pulse)
                        .scaledToFit()
                        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
                        .shadow(radius: 12)
                        .shadow(radius: 6)
                        .hoverEffect(.automatic)
                        .padding([.trailing, .leading], 5)
                        .frame(width: size.width / 4.5, height: size.height / 4.5, alignment: .center)
                        .position(x: size.width / 6, y: size.height / 8)
                        .onTapGesture {
                            pulse = false
                            self.showModal = true
                            modalView = modalChoices.moodPicker
                        }
                    if Array(logicView.reactionsToMe.values).count != 0 {
                        Image(Array(logicView.reactionsToMe.values)[currentlyShownReaction]) // by clicking go through reactions to you
                            .resizable()
                            .pulsating(pulse: $pulse)
                            .scaledToFit()
                            .padding([.trailing, .leading], 5)
                            .frame(width: size.width / 4, height: size.height / 6.0, alignment: .center)
                            .position(x: size.width / 6, y: size.height / 8)
                            .onTapGesture {
                                pulse = false
                                if currentlyShownReaction < Array(logicView.reactionsToMe.values).count - 1 {
                                    currentlyShownReaction += 1
                                } else {
                                    currentlyShownReaction = 0
                                }
                            }
                    }
                }
                VStack {
                    Text("I feel ...")
                        .font(.custom("Galvji", size: min(size.width, size.height) *  0.06))
                        .fontWeight(.bold)
                        .padding([.leading, .trailing])
                        .foregroundColor(.black)
                    Text("\(logicView.currentMood)")
                        .font(.custom("Galvji", size: min(size.width, size.height) *  0.045))
                        .multilineTextAlignment(.center)
                        .padding([.trailing, .leading], 5)
                        .foregroundColor(.black)
                }
                .position(x: size.width / 5, y: size.height / 8)
            }
            .frame(height: size.height/4, alignment: .center)
            .padding([.leading, .trailing])
        }
        .onAppear { // go over animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                pulse = true
            }
        }
        Divider()
            .background(Constants.goldOutline)
            .frame(height: 4)
            .padding([.trailing, .leading], 5)
    }
    
    @ViewBuilder
    private func friendsInfo(for size: CGSize) -> some View {
        ScrollView() {
            ForEach(logicView.friends, id: \.self) { friend in
                HStack (spacing: 0) {
                    VStack(spacing: 0) {
                        ZStack {
                            Image(friend.currentMood)
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                .shadow(radius: 4)
                                .shadow(radius: 2)
                                .hoverEffect(.automatic)
                                .padding([.trailing, .leading], 10)
                                .frame(width: size.width / 2.5, height: frameSizeHeight(for: size), alignment: .center)
                            Image(logicView.reactions[friend.id] ?? "Lock")
                                .resizable()
                                .scaledToFit()
                                .shadow(radius: 4)
                                .shadow(radius: 2)
                                .frame(width: size.width/8, height: size.height/11, alignment: .center)
                                .onTapGesture {
                                    pulse = false
                                    logicView.currentlyReactingTo = friend.id
                                    self.showModal = true
                                    modalView = modalChoices.stickerPicker
                                }
                        }
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Text(friend.name)
                                .bold()
                                .font(.custom("Galvji", size: min(size.width, size.height) *  0.06))
                                .padding([.trailing, .leading], 5)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            Text("\(friend.currentMood)")
                                .font(.custom("Galvji", size: min(size.width, size.height) *  0.045))
                                .frame(alignment: .center)
                                .padding([.trailing, .leading], 5)
                                .foregroundColor(.black)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    Spacer()
                    Image(systemName: "person.crop.circle.fill.badge.minus")
                        .font(.custom("Galvji", size: fontSize(for: size)))
                        .foregroundColor(Constants.goldOutline)
                        .onTapGesture {
                            print("pressed")
                            self.showConfirmation = true
                            remFriend = friend
                            print(self.showConfirmation, remFriend)
                        }
                        .padding(.trailing, 5)
                        .alert(isPresented: $showConfirmation) { () -> Alert in
                            Alert(title: Text("Remove Friend"), message: Text("Do you really want to remove this friend?"), primaryButton: .default(Text("Yes"), action: {
                                logicView.removeFriend(friend: remFriend)
                                logicView.sendPushNotificationForRemovedFriend(id: remFriend.id)
                                showConfirmation = false
                            }), secondaryButton: .default(Text("No"), action: {
                                showConfirmation = false
                            }))
                        }
                    
                }
                Divider()
                    .background(Constants.goldOutline)
                    .frame(height: 1)
                    .padding([.leading, .trailing], 5)
            }
        }
    }
    
    private func save(_ friends: [Friend]) {
        guard let topFriendsMoodData = try? JSONEncoder().encode(friends) else { return }
        self.topFriendsMoodData = topFriendsMoodData
    }
    
    private func convertMoodStrToMyMood(_ moodStr: String) -> myMood {
        var realMood = Constants.myMoods[0]
        
        for mood in Constants.myMoods {
            if mood.name == moodStr {
                realMood = mood
            }
        }
        return realMood
    }
    
}

struct Pulsating: ViewModifier {
    @Binding var pulse: Bool
    @State var animate: Bool = false
    @EnvironmentObject var logicView: LogicView
    
    func body(content: Content) -> some View {
        content
//            .animation(nil)
            .scaleEffect(animate ? 1 : 0.95) // pulse
            .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true)) // pulse ?  : nil
            .onAppear{ self.animate = true }
            .onDisappear{ self.animate = false }
    }
    
}

extension View {
    func pulsating(pulse: Binding<Bool>) -> some View {
        self.modifier(Pulsating(pulse: pulse))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMoodView()
    }
}

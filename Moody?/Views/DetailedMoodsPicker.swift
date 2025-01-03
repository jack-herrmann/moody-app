//
//  DetailedMoodsPicker.swift
//  Moody?
//
//  Created by Jack Herrmann on 09.10.21.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseAuth

struct DetailedMoodsPicker: View {
    @EnvironmentObject var logicView: LogicView
    @Environment(\.presentationMode) var presentation
    
    @Binding var set: Bool
    @Binding var rem: Bool
    @Binding var pulse: Bool
        
    private let columns = [ GridItem(.flexible())]
    
    init(set: Binding<Bool>, rem: Binding<Bool>, pulse: Binding<Bool>) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().backgroundColor = UIColor(Constants.lightYellowAccent)
        self._set = set
        self._rem = rem
        self._pulse = pulse
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
        .environmentObject(logicView)
    }
    
    private func body (for size: CGSize) -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Constants.myMoodBundles, id: \.self) { moodBundle in
                        segment(for: size, moodBundle: moodBundle)
                    }
                }
                .padding(10)
            }
        }
        .foregroundColor(.black)
        .cornerRadius(15)
        .background(LinearGradient(gradient: Gradient(colors: [Constants.lightYellowAccent, Constants.lightYellowAccent]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all))
        .statusBar(hidden: true)
    }
    
    @ViewBuilder
    private func segment(for size: CGSize, moodBundle: [myMood]) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Constants.yellowUnderline)
                .shadow(radius: 5)
                .frame(width: size.width*0.95)
            HStack (spacing: 0) {
                ForEach(moodBundle, id: \.self) { mood in
                    VStack {
                        if moodBundle.firstIndex(matching: mood) == 2 {
                            VStack {
                                Image(mood.img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: min(size.width, size.height)/(5/1.025), height: min(size.width, size.height)/(5/1.025))
                                    .shadow(radius: 4)
                                    .shadow(radius: 2)
                                Text(mood.name)
                                    .font(.custom("Galvji", size: min(size.width, size.height) *  0.026))
                                    .fontWeight(.semibold)
                                    .padding(3)
                            }
                            .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Constants.goldOutline, lineWidth: 2))
                            .padding(5)
                            .onTapGesture {
                                logicView.chooseMood(mood: mood.name)
                                logicView.sendPushNotificationToAllFriendsForMoodsAndStickers()
                                set = true
                                rem = true
                                pulse = true
                            }
                        } else {
                            VStack {
                                Image(mood.img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: min(size.width, size.height)/5.8, height: min(size.width, size.height)/5.8)
                                    .shadow(radius: 4)
                                    .shadow(radius: 2)
                                Text(mood.name)
                                    .font(.custom("Galvji", size: min(size.width, size.height) *  0.025))
                                    .padding(2.5)
                            }
                            .onTapGesture {
                                logicView.chooseMood(mood: mood.name)
                                logicView.sendPushNotificationToAllFriendsForMoodsAndStickers()
                                set = true
                                rem = true
                                pulse = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            set = true
            rem = true
            pulse = true
        }
        .foregroundColor(Constants.goldOutline)
    }
}

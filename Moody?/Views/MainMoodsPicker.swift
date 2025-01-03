//
//  MainMoodsPicker.swift
//  Moody?
//
//  Created by Jack Herrmann on 09.10.21.
//

// need to dismiss parent view

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseAuth

struct MainMoodsPicker: View {
    @EnvironmentObject var logicView: LogicView
    @Environment(\.presentationMode) var presentation
    
    @Binding var set: Bool
    @Binding var rem: Bool
    @Binding var pulse: Bool
        
    private let columns = [ GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()) ]
    
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
        GeometryReader { reader in
                VStack {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(Constants.myMoods, id: \.self) { mood in
                                segment(for: reader.size, mood: mood)
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
    }
    
    @ViewBuilder
    private func segment(for size: CGSize, mood: myMood) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Constants.yellowUnderline)
                .shadow(radius: 5)
            VStack {
                Image(mood.img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(size.width, size.height)/3.5, height: min(size.width, size.height)/3.5)
                    .shadow(radius: 4)
                    .shadow(radius: 2)
                Text(mood.name)
                    .font(.custom("Galvji", size: min(size.width, size.height) *  0.035))
                    .padding(10)
            }
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

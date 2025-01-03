//
//  StickerView.swift
//  Moody?
//
//  Created by Jack Herrmann on 04.05.21.
//

import SwiftUI

struct StickerView: View {
    @EnvironmentObject var logicView: LogicView
    @Environment(\.presentationMode) var presentation
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    init(pulse: Binding<Bool>) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        self._pulse = pulse
    }
    
    @Binding var pulse: Bool
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
        .environmentObject(logicView)
    }
    
    private func body (for size: CGSize) -> some View {
        GeometryReader { reader in
            NavigationView {
                VStack {
                    if !(logicView.premium) {
                        Button {
                            logicView.buyPremium()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Constants.goldOutline)
                                    .overlay(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Constants.goldOutline, lineWidth: 2))
                                    .frame(height: reader.size.height / 17)
                                    .shadow(radius: 5)
                                    .padding()
                                Text("Buy Reactions")
                                    .foregroundColor(Color.black)
                                    .font(.custom("Galvji", size: min(size.width, size.height) *  0.042))
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(Constants.stickers, id: \.self) { sticker in
                                segment(for: reader.size, sticker: sticker)
                            }
                        }
                        .padding()
                    }
                }
                .cornerRadius(15)
                .background(LinearGradient(gradient: Gradient(colors: [Constants.lightYellowAccent, Constants.lightYellowAccent]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .edgesIgnoringSafeArea(.all))
                .navigationBarItems(trailing: cancel)
                .navigationBarTitle("Reactions")
                .blueNavigation
            }
            .statusBar(hidden: true)
        }
    }
    
    @ViewBuilder
    private func segment(for size: CGSize, sticker: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Constants.yellowUnderline)
                .shadow(radius: 5)
            Button(action: {
                print("tapped")
                logicView.reactTo(id: logicView.currentlyReactingTo, reaction: sticker)
    //            logicView.chooseSticker(sticker: sticker) // change func
                logicView.sendPushNotificationToAllFriendsForMoodsAndStickers() // change receivers
                pulse = true
                self.presentation.wrappedValue.dismiss()
            }, label: {
                Locked(for: size, sticker: sticker)
            })
        }
//        .onTapGesture {
//            print("tapped")
//            logicView.reactTo(id: logicView.currentlyReactingTo, reaction: sticker)
////            logicView.chooseSticker(sticker: sticker) // change func
//            logicView.sendPushNotificationToAllFriendsForMoodsAndStickers() // change receivers
//            pulse = true
//            self.presentation.wrappedValue.dismiss()
//        }
    }
    
    @ViewBuilder
    private func Locked(for size: CGSize, sticker: String) -> some View {
        ZStack {
            Image(sticker)
                .resizable()
                .scaledToFit()
                .frame(width: size.width / 3.75, height: size.height / 8.5)
                .opacity(logicView.premium ? 1 : 0)
                .padding([.top, .bottom], 5)
//                .onTapGesture {
//                    logicView.chooseSticker(sticker: sticker)
//                    self.presentation.wrappedValue.dismiss()
//                }
            if logicView.premium == false {
                Image(Constants.lock)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width / 3.75, height: size.height / 8.5)
                    .padding([.top, .bottom], 5)
                    .allowsHitTesting(false)
            }
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            pulse = true
            self.presentation.wrappedValue.dismiss()
        }
        .foregroundColor(Constants.goldOutline)
    }
}


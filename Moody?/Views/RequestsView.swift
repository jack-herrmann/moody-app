//
//  RequestsView.swift
//  Moody?
//
//  Created by Jack Herrmann on 10.08.21.
//


// currRequest and person variables are = id not email

import SwiftUI

struct RequestsView: View {
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject var logicView: LogicView
    
    @Binding var pulse: Bool
    @State private var currRequest: String = ""
    @State private var presentNameModal: Bool = false
    @State private var containedAlertIsShown = false
    @State private var newName: String = ""
    @State private var contained = false
    @State private var chosenOption = "Received"
    var options = ["Received", "Sent"]
    
    init(pulse: Binding<Bool>) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Constants.goldOutline)
        UISegmentedControl.appearance().backgroundColor = UIColor(Constants.lightYellowAccent)
        self._pulse = pulse
    }
    
    var body: some View {
        GeometryReader { reader in
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Constants.lightYellowAccent, Constants.lightYellowAccent]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Picker("", selection: $chosenOption) {
                            ForEach(options, id: \.self) {
                                Text($0)
                            }
                            .background(Constants.lightYellowAccent)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Constants.lightYellowAccent)
                        if chosenOption == "Received" {
                            if logicView.receivedRequests.isEmpty && chosenOption == "Received" {
                                Text("You have not received any new requests")
                                    .font(.callout)
                                    .foregroundColor(.black)
                                Spacer()
                            } else {
                                ScrollView {
                                    ForEach(logicView.receivedRequests, id: \.self) { person in // person needs to be email
                                        HStack {
                                            Text("Hey, \(person) would like to connect!")
                                                .font(.callout)
                                                .foregroundColor(.black)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                                .font(.largeTitle)
                                                .foregroundColor(.green)
                                                .onTapGesture {
                                                    currRequest = person
                                                    presentNameModal = true
                                                }
                                            Image(systemName: "xmark")
                                                .font(.largeTitle)
                                                .foregroundColor(.red)
                                                .onTapGesture {
                                                    logicView.declineRequest(email: person)
                                                    logicView.getIdViaEmail(email: person) { id in
                                                        logicView.sendPushNotificationForDeclinedRequest(id: id)
                                                    }
                                                }
                                        }
                                        .padding()
                                        Divider()
                                            .background(Constants.goldOutline)
                                            .frame(height: 1)
                                            .padding([.leading, .trailing], 5)
                                    }
                                }
                            }
                        } else {
                            if logicView.sentRequests.isEmpty && chosenOption == "Sent" {
                                Text("None of the requests you have sent are still open")
                                    .font(.callout)
                                    .foregroundColor(.black)
                                Spacer()
                            } else {
                            ScrollView {
                                ForEach(logicView.sentRequests, id: \.self) { person in
                                    let splitArr = person.split(separator: " ")
                                    HStack {
                                        Text("You have sent a requests to \(String(splitArr[0])) (\(String(splitArr[1])))")
                                            .font(.callout)
                                            .foregroundColor(.black)
                                            .padding()
                                        Spacer()
                                    }
                                    Divider()
                                        .background(Constants.goldOutline)
                                        .frame(height: 1)
                                        .padding([.leading, .trailing], 5)
                                }
                            }
                        }
                        }
                    }
                    CustomAlert_oneTF(isShown: $presentNameModal, text: $newName, title: "Choose name", onDone: { (text) in
                        for friend in logicView.friends {
                            if friend.name == text {
                                contained = true
                            }
                        }
                        if contained {
                            containedAlertIsShown = true
                        } else {
                            logicView.getIdViaEmail(email: currRequest) { id in
                                logicView.acceptRequest(email: currRequest, id: id, givenName: text)
                                logicView.sendPushNotificationForAcceptedRequest(id: id)
                            }
                        }
                        newName = ""
                    })
                }
                .alert(isPresented: $containedAlertIsShown) { () -> Alert in
                    Alert(title: Text("Invalid"), message:  Text("Either you have already added a friend"), dismissButton: .default(Text("OK")) {
                        containedAlertIsShown = false
                        contained = false
                    })
                }
                .navigationBarTitle("Requests")
                .navigationBarItems(trailing:
                                        Button(action: {
                    pulse = true
                    self.presentation.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                        .foregroundColor(Constants.goldOutline)
                }))
                
            }
            .blueNavigation
            .statusBar(hidden: true)
        }
    }
}

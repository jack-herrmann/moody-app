//
//  LoginView.swift
//  Moody?
//
//  Created by Jack Herrmann on 11.07.21.
//

import SwiftUI
import Firebase
import FirebaseMessaging

struct LoginView: View {
    
    @EnvironmentObject var logicView: LogicView
    @State var user: UserViewModel = UserViewModel()
    @Binding var showSheet: Bool
    @Binding var action: ActionSheet.Action?
    @State private var showAlert = false
    @State private var showAlertAlreadySignedIn = false
    @State private var authError: EmailAuthError?
    
    var body: some View {
        GeometryReader { reader in
            ZStack() {
                LinearGradient(gradient: Gradient(colors: [Constants.lightYellowAccent, Constants.lightYellowAccent]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                Image("Logo4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: reader.size.width / 1.1, alignment: .center)
                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
                    .padding(10)
                    .blur(radius: 3)
                    .position(x: reader.size.width / 2, y: reader.size.height / 2)
                VStack {
                    Spacer()
                    Text("Socialise").foregroundColor(.black).font(.custom("Savoye LET", size: min(reader.size.height, reader.size.width) * 0.3)).fontWeight(.black)
                    Spacer()
                    Spacer()
                    Spacer()
                    Group {
                        Rectangle()
                            .foregroundColor(Constants.lightYellowAccent)
                            .border(Constants.goldOutline, width: 2)
                            .opacity(0.75)
                            .overlay(TextField("", text: $user.email).padding().placeholder(when: user.email.isEmpty) {Text("Enter Email...").foregroundColor(.gray)}.foregroundColor(.black).font(.title3).autocapitalization(.none).disableAutocorrection(true).keyboardType(.emailAddress))
                            .frame(width: reader.size.width*0.65, height: (reader.size.width*0.65)/4.5)
                        Rectangle()
                            .foregroundColor(Constants.lightYellowAccent)
                            .border(Constants.goldOutline, width: 2)
                            .opacity(0.75)
                            .overlay(SecureField("", text: $user.password).padding().placeholder(when: user.password.isEmpty) {Text("Enter Password...").foregroundColor(.gray)}.foregroundColor(.black).font(.title3).autocapitalization(.none).disableAutocorrection(true))
                            .frame(width: reader.size.width*0.65, height: (reader.size.width*0.65)/4.5)
                        HStack {
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Button(action: {
                                action = .resetPW
                                showSheet = true
                            }) {
                                Text("Forgot Password")
                                    .foregroundColor(.blue)
                                    .font(.callout)
                            }
                            Spacer()
                            Spacer()
                        }
                        Spacer()
                    }
                    Group {
                        Button(action: {
                            logicView.getIdViaEmail(email: self.user.email) { nId in
                                FBFirestore.retrieveFBUser(uid: nId) { (result) in
                                    switch result {
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    case .success(let user):
                                        if user.fcmToken != "" {
                                            FBAuth.authenticate(withEmail: self.user.email, password: self.user.password) { (result) in
                                                switch result {
                                                case .failure(let error):
                                                    self.authError = error
                                                    self.showAlert = true
                                                case .success( _):
                                                    logicView.configureFirebaseStateDidChange {
                                                        logicView.updateSelf()
                                                        logicView.updateFriends()
//                                                        let pushManager = PushNotificationManager()
//                                                        pushManager.registerForPushNotifications()
                                                    }
                                                }
                                            }
                                        } else {
                                            self.showAlertAlreadySignedIn = true
                                        }
                                    }
                                }
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Constants.goldOutline)
                                    .opacity(0.8)
                                    .frame(width: reader.size.width*0.65, height: (reader.size.width*0.65)/3.5)
                                Text("Login")
                                    .foregroundColor(.black)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            .opacity(user.isLoginComplete ? 1 : 0.7)
                        }
                        .disabled(!user.isLoginComplete)
                        Spacer()
                        Spacer()
                        Spacer()
                        Button(action: {
                            action = .signUp
                            showSheet = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Constants.goldOutline)
                                    .opacity(0.75)
                                    .frame(width: reader.size.width*0.55, height: (reader.size.width*0.65)/4.5)
                                Text("Sign Up")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                .position(x: reader.size.width / 2, y: reader.size.height / 2)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Error"), message: Text(self.authError?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("OK")) {
                    if self.authError == .incorrectPassword {
                        user.password = ""
                    } else {
                        self.user.password = ""
                        self.user.email = ""
                    }
                })
            }
            .alert(isPresented: $showAlertAlreadySignedIn) {
                Alert(title: Text("Login Error"), message: Text("This user is already signed in!"), dismissButton: .default(Text("OK")) {})
            }
        }
        .statusBar(hidden: true)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0).padding()
            self
        }
    }
}

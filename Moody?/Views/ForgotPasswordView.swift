//
//  ForgotPasswordView.swift
//  Moody?
//
//  Created by Jack Herrmann on 31.07.21.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State var user: UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var errorString: String?
    
    var body: some View {
        GeometryReader { reader in
            NavigationView {
                VStack {
                    ZStack {
                        Constants.lightYellowAccent
                            .edgesIgnoringSafeArea(.all)
                        Image("Logo4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: reader.size.width / 1.1, alignment: .center)
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
                            .padding(10)
                            .blur(radius: 3)
                            .position(x: reader.size.width / 2, y: reader.size.height / 2.4)
                        VStack {
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
                                Spacer()
                            }
                            Group {
                                Button(action: {
                                    FBAuth.resetPassword(email: user.email) { (result) in
                                        switch result {
                                        case .failure(let error):
                                            self.errorString = error.localizedDescription
                                        case .success( _):
                                            break
                                        }
                                        self.showAlert = true
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundColor(Constants.goldOutline)
                                            .opacity(0.8)
                                            .frame(width: reader.size.width*0.65, height: (reader.size.width*0.65)/3.5)
                                        Text("Reset")
                                            .foregroundColor(.black)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                    }
                                }
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                            }
                        }
                    }
                }
                .blueNavigation
                .navigationBarTitle(Text("Forgot Password"))
                .navigationBarItems(trailing: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Password Reset"), message: Text(self.errorString ?? "Success, reset email sent successfully! Check your inbox."), dismissButton: .default(Text("OK")) {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
            }
            .statusBar(hidden: true)
        }
    }
}

extension View {
  func navigationBarColor(_ backgroundColor: UIColor, textColor: UIColor) -> some View {
    self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, textColor: textColor))
  }
}

extension View {
  var blueNavigation: some View {
      self.navigationBarColor(UIColor(Constants.lightYellowAccent), textColor: UIColor.black)
  }
}


struct NavigationBarModifier: ViewModifier {
  var backgroundColor: UIColor
  var textColor: UIColor

  init(backgroundColor: UIColor, textColor: UIColor) {
    self.backgroundColor = backgroundColor
    self.textColor = textColor
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithTransparentBackground()
    coloredAppearance.backgroundColor = .clear
    coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]

    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = textColor
  }

  func body(content: Content) -> some View {
    ZStack{
       content
        VStack {
          GeometryReader { geometry in
             Color(self.backgroundColor)
                .frame(height: geometry.safeAreaInsets.top)
                .edgesIgnoringSafeArea(.top)
              Spacer()
          }
        }
     }
  }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}


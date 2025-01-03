//
//  ActionSheet.swift
//  Moody?
//
//  Created by Jack Herrmann on 13.07.21.
//

import SwiftUI

struct ActionSheet: View {
    
    enum Action {
        case signUp, resetPW
    }
    
    @State private var showSheet = false
    @State private var action: Action?
    
    var body: some View {
        LoginView(showSheet: $showSheet, action: $action)
            .fullScreenCover(isPresented: $showSheet) { [action] in
                if action == .signUp {
                    SignUpView()
                } else if action == .resetPW {
                    ForgotPasswordView()
                }
            }
    }
}

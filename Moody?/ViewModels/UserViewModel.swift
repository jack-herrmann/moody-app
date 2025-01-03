//
//  UserViewModel.swift
//  Moody?
//
//  Created by Jack Herrmann on 14.07.21.
//

import Foundation

struct UserViewModel {
        
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    func passwordsMatch(_confirmPW: String) -> Bool {
        return _confirmPW == password
    }
    
    func isEmpty(_field: String) -> Bool {
        return _field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isEmailValid(_email: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return passwordTest.evaluate(with: email)
    }
    
    func isPasswordValid(_password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    var isSignInComplete: Bool {
        if !isEmailValid(_email: email) || !isPasswordValid(_password: password) || !passwordsMatch(_confirmPW: confirmPassword) {
            return false
        }
        return true
    }
    
    var isLoginComplete: Bool {
        if isEmpty(_field: email) || isEmpty(_field: password) {
            return false
        }
        return true
    }
    
    var validEmailAddressText: String {
        if isEmailValid(_email: email) {
            return ""
        } else {
            return "Enter a valid E-mail address"
        }
    }
    
    var validPasswordText: String {
        if isPasswordValid(_password: password) {
            return ""
        } else {
            return "Must be at least 8 characters containg at least one capital letter and one number!"
        }
    }
    
    var validConfirmPasswordText: String {
        if passwordsMatch(_confirmPW: confirmPassword) {
            return ""
        } else {
            return "Passwords don't match"
        }
    }
    
}

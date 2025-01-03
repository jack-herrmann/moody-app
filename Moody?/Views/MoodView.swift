//
//  MoodView.swift
//  Moody?
//
//  Created by Jack Herrmann on 09.10.21.
//

import SwiftUI

struct MoodView: View {
    
    @Environment(\.presentationMode) var presentation
    
    init(set: Binding<Bool>, pulse: Binding<Bool>) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().backgroundColor = UIColor(Constants.lightYellowAccent)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Constants.goldOutline)
        UISegmentedControl.appearance().backgroundColor = UIColor(Constants.lightYellowAccent)
        self._set = set
        self._pulse = pulse
    }
    
    @Binding var pulse: Bool
    @Binding var set: Bool
    @State var rem: Bool = false
    @State private var chosenOption = "Main"
    var options = ["Main", "Detailed"]
    
    var body: some View {
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
                    if chosenOption == "Main" {
                        MainMoodsPicker(set: $set, rem: $rem, pulse: $pulse)
                    } else {
                        DetailedMoodsPicker(set: $set, rem: $rem, pulse: $pulse)
                    }
                }
                .navigationBarItems(trailing: cancel)
                .navigationBarTitle("I feel...")
                .blueNavigation
                .onChange(of: rem) { _ in
                    if rem {
                        pulse = true
                        self.presentation.wrappedValue.dismiss()
                    }
                    rem = false
                }
            }
        }
        .statusBar(hidden: true)
    }
    
    var cancel: some View {
        Button("Cancel") {
            pulse = true
            self.presentation.wrappedValue.dismiss()
        }
        .foregroundColor(Constants.goldOutline)
    }
    
}

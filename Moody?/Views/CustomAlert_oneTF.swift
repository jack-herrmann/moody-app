//
//  CustomAlert_oneTF.swift
//  Moody?
//
//  Created by Jack Herrmann on 10.08.21.
//

import SwiftUI

struct CustomAlert_oneTF: View {
    @Binding var isShown: Bool
    @Binding var text: String
    var title: String = "Choose name"
    var onDone: (String) -> Void = { text in }
    var onCancell: () -> Void = { }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if isShown {
                    LinearGradient(gradient: Gradient(colors: [Constants.lightYellowAccent, Constants.lightYellowAccent]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 10)
                    LinearGradient(gradient: Gradient(colors: [Constants.lightYellowAccent, Constants.lightYellowAccent]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 50)
                }
                VStack {
                    Text(title)
                        .font(.custom("Galvji", size: min(reader.size.width, reader.size.height) *  0.055))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                    ZStack(alignment: .leading) {
                        if text.isEmpty { Text("Name your friend...")
                            .foregroundColor(.gray)
                            .padding(.all, 10)
                            .font(.custom("Galvji", size: min(reader.size.width, reader.size.height) *  0.035))}
                        TextField("", text: $text)
                            .disableAutocorrection(true)
                            .padding(.all, 10)
                            .font(.custom("Galvji", size: min(reader.size.width, reader.size.height) *  0.035))
                            .foregroundColor(.black)
                            .border(Constants.goldOutline, width: 1.0)
                    }
                    Spacer()
                    Divider()
                    HStack {
                        Button("Done") {
                            onDone(text)
                            UIApplication.shared.endEditing()
                            isShown = false
                        }
                        Spacer()
                        Button("Cancel") {
                            onCancell()
                            UIApplication.shared.endEditing()
                            isShown = false
                        }
                    }
                    .padding([.leading, .trailing])
                    .padding([.leading, .trailing])
                    .font(.custom("Galvji", size: min(reader.size.width, reader.size.height) *  0.04))
                    .foregroundColor(.black)
                }
                .padding()
                .background(Constants.lightYellowAccent)
                .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
                .shadow(color: Constants.goldOutline, radius: 15, x: 0, y: 0)
                .frame(width: reader.size.width * 0.6, height: reader.size.height * 0.25)
                .position(x: reader.size.width / 2, y: isShown ? reader.size.height / 2 : reader.size.height * 5)
            }
            .animation(.spring().speed(0.6))
        }
    }
}

struct CustomAlert_oneTF_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert_oneTF(isShown: .constant(true), text: .constant(""))
    }
}


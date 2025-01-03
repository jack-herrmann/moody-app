//
//  Success.swift
//  Moody?
//
//  Created by Jack Herrmann on 16.09.21.
//

import SwiftUI

struct Success: View {
    
    @Binding var isShown: Bool
    
    var body: some View {
        GeometryReader { reader in
                ZStack {
                    Circle()
                        .font(.title)
                        .foregroundColor(.green)
                    Image(systemName: "checkmark")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Constants.lightYellowAccent)
                .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
                .shadow(color: Constants.goldOutline, radius: 15, x: 0, y: 0)
                .frame(width: reader.size.width * 0.4, height: reader.size.height * 0.15)
                .animation(.spring().speed(0.6))
                .position(x: reader.size.width / 2, y: isShown ? reader.size.height / 2 : reader.size.height * 2)
        }
    }
}

struct Success_Previews: PreviewProvider {
    static var previews: some View {
        Success(isShown: .constant(true))
    }
}

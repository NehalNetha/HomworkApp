//
//  InputView.swift
//  firebase-practice
//
//  Created by NehalNetha on 18/01/24.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text: String
    let placeholder: String
    var secureField = false
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFoused: Bool

    
    var body: some View {
        VStack{
            
           
            
            if secureField{
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(isEmailFocused ? Color(hex: "4A90E2") : Color(hex: "E0E0E0"), lineWidth: 2)
                    )

                    .foregroundColor(.black)
                    .autocapitalization(.none)
                    .focused($isEmailFocused)
            }else{
                TextField(placeholder, text: $text)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(isEmailFocused ? Color(hex: "4A90E2") : Color(hex: "E0E0E0"), lineWidth: 2)
                    )

                    .foregroundColor(.black)
                    .autocapitalization(.none)
                    .focused($isEmailFocused)

            }
        }
    }
}

#Preview {
    InputView(text: .constant(""), placeholder: "example@gmail.com")
}

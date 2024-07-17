//
//  ToggleButton.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 27/06/24.
//

import SwiftUI

struct ToggleButton: View {
    @State private var isChecked = false
    var body: some View {
        VStack{
            Button{
                isChecked.toggle()
            } label: {
                Image(systemName: isChecked ? "checkmark.circle" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(isChecked ? .blue : .gray)
            }
        }
    }
}

#Preview {
    ToggleButton()
}

//
//  NavbarView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 17/06/24.
//

import SwiftUI

struct NavbarView: View {
    var body: some View {
        HStack{
            HStack(spacing: 15){
                Image(systemName: "person")
                    .padding()
                    .font(.title2)
                    .background(
                        Circle()
                            .fill(.white)
                            .strokeBorder(.gray, lineWidth: 1)
                    )
                
                VStack(alignment: .leading){
                    Text("Nehal Netha")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Evening nihal")
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            Button{
                
            }label: {
                Image(systemName: "bell")
                    .foregroundStyle(.black)
                    .font(.title2)
            }
            .padding()
            .background(
                Circle()
                    .fill(.white)
                    .strokeBorder(.gray, lineWidth: 1)
            )
        }
        .padding()
    }
}

#Preview {
    NavbarView()
}

//
//  ProgressBar.swift
//  HomeworkApp
//
//  Created by NehalNetha on 09/05/24.
//

import SwiftUI


struct ProgressBar: View {
    let progress: Double
    let numberOfBlocks: Int
    let blockColor: Color
    let widthBlock: CGFloat
    
    var body: some View {
        HStack {
            ForEach(0..<Int(numberOfBlocks)) { index in
                RoundedRectangle(cornerRadius: 10)
                    .fill(index < Int(Double(numberOfBlocks) * progress) ? blockColor : Color.gray)
                    .opacity(index < Int(Double(numberOfBlocks) * progress) ? 1.0 : 0.5)
                    .frame(width: widthBlock, height: 4) // Adjust the size of the blocks
                    .padding(.horizontal, 2) // Adjust the spacing between blocks

            }
        }
    }
}


#Preview {
    ProgressBar(progress: 30, numberOfBlocks: 6, blockColor: .blue, widthBlock: 30)
}

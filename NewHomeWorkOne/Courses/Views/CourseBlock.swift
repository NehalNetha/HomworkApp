//
//  CoureBlock.swift
//  HomeworkApp
//
//  Created by NehalNetha on 11/06/24.
//

import SwiftUI

struct CoureBlock: View {
    var courseName: String
    var courseDescription: String
    @EnvironmentObject var assignViewModel: AssignmentViewModel


    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(courseName)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(courseDescription)
                        .foregroundStyle(Color(hex: "E9E9E9"))
                }
                Spacer()
                
                Menu{
                    Button("delete"){
                        
                    }
                }label: {
                    
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
        .frame(width: 250, height: 80)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color(hex: "3E6EE8"))
                .shadow(color: .gray, radius: 5, x: 3, y: 3)

        )
        
    }
}

#Preview {
    CoureBlock(courseName: "Linear Algebra", courseDescription: "You have 10 assignments")
}

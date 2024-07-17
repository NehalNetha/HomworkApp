//
//  BlockAssignment.swift
//  HomeworkApp
//
//  Created by NehalNetha on 09/05/24.
//

import SwiftUI

struct BlockAssignment: View {
    
    var assignmentTitle: String
    var courseName: String
    var deadlineDate: Date
    var assId: String
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel

    
    var body: some View {
        VStack(spacing: 8){
            HStack{
                VStack(alignment: .leading, spacing: 5){
                    Text(assignmentTitle)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top)
                    Text(courseName )
                        .foregroundStyle(Color(hex: "E9E9E9"))
                }
                Spacer()
                Menu{
                    Button("delete"){
                        Task{
                            try? await assignmentViewModel.deleteAssignment(assignmentId: assId)
                        }
                    }
                }label: {
                    
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            VStack(alignment: .leading){
                HStack{
                    Text("Progress")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("54%")
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                }
                ProgressBar(progress: 0.6, numberOfBlocks:5 , blockColor: .white, widthBlock: 30)
            }
            
            HStack{
                Spacer()
                Image(systemName: "calendar")
                Text(DateUtils.formattedDate(deadlineDate))
            }
            .padding(.horizontal)
            .padding(.bottom)
            .foregroundStyle(.white)
        }
        .padding()
        .frame(width: 300, height: 170)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color(hex: "3E6EE8"))
                .shadow(color: .gray, radius: 5, x: 3, y: 3)

        )
    }
    

}

#Preview {
    BlockAssignment(assignmentTitle: "Assignment Name", courseName: "course Title", deadlineDate: Date(), assId: "")
}

//
//  BlockAssignment.swift
//  HomeworkApp
//
//  Created by NehalNetha on 09/05/24.
//

import SwiftUI

struct CourseAssignmentBlock: View {
    
    var assignmentTitle: String
    var courseName: String?
    var deadlineDate: Date
    var assId: String?
    @EnvironmentObject var assignViewModel: AssignmentViewModel

    
    var body: some View {
        VStack(spacing: 8){
            
            HStack{
                VStack(alignment: .leading, spacing: 5){
                    Text(assignmentTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top)
                    Text(courseName ?? "")
                        .foregroundStyle(.gray)
                        .opacity(0.7)
                }
                .foregroundStyle(.black)
                Spacer()
                Menu{
                    Button("delete"){
                            
                        withAnimation(.easeInOut){
                            assignViewModel.assignmentsByCourse.removeAll() {$0.id == assId}
                        }

                        
                            Task{
                                    
                                try? await assignViewModel.deleteAssignment(assignmentId: assId ?? "")
                            }
                    }
                }label: {
                    
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
            
            VStack(alignment: .leading){
                HStack{
                    Text("Progress")
                        .foregroundStyle(.black)
                    Spacer()
                    Text("54%")
                        .foregroundStyle(.black)
                        .font(.system(size: 15))
                }
                ProgressBar(progress: 0.6, numberOfBlocks:5 , blockColor: .black, widthBlock: 30)
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
        .padding(.leading)
        .frame(width: 355, height: 170)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 2, x: 2, y: 2)

        )
    }
    

}

#Preview {
    CourseAssignmentBlock(assignmentTitle: "Assignment Name", courseName: "course Title", deadlineDate: Date(), assId: "")
}

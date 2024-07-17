//
//  AssignmentTaskView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 24/06/24.
//

import SwiftUI

struct AssignmentTaskView: View {
    @State private var showTaskToggle = false
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Binding var ass: AssignmentModel
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            VStack{
                
                HStack{
                    
                    
                    VStack(alignment: .leading){
                        Text("Tasks")
                            .font(.system(size: 26))
                            .fontWeight(.semibold)
                            .padding(.trailing)
                        HStack{
                            
                            Text("\(DateUtils.getDayOfWeek()) , \(DateUtils.getDate()) \(DateUtils.getMonth()) " )
                                .font(.system(size: 12))
                            
                            
                        }
                        .foregroundStyle(.gray)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button{
                        showTaskToggle.toggle()
                        
                    }label: {
                        HStack{
                            Image(systemName: "plus")
                                .foregroundStyle(Color(hex: "1758D6"))
                            Text("New Task")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(hex: "1758D6"))
                        }
                        .padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13 ))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(hex: "ACD2FF"))
                        )
                    }
                    .padding(.trailing)
                    .sheet(isPresented: $showTaskToggle){
                        AssignmentAddingTasks(assingmentId: ass.id ?? "")
                            .environmentObject(taskViewModel)
                    }
                    
                }
                TaskDisplayView(tasks: $taskViewModel.taskByAss, openCount: taskViewModel.openTaskCountAss, doneCount: taskViewModel.doneTaskCountAss, archivedCount: taskViewModel.archivedTaskCountAss, allCount: taskViewModel.allTasksAss)
                    .environmentObject(taskViewModel)
                Spacer()

            }
        }
    }
    
}

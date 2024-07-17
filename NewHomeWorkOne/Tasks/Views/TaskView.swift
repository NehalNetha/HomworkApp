//
//  TaskView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 17/06/24.
//

import SwiftUI

struct TaskView: View {
    
    @State private var showTaskToggle = false
    @EnvironmentObject var taskViewModel : TaskViewModel

    @State private var filter: TaskModel.TaskStatus?
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            NavigationStack{
                VStack {
                    HStack{
                        VStack(alignment: .leading){
                            Text("Tasks")
                                .font(.system(size: 26))
                                .fontWeight(.semibold)
                            HStack{
                                
                                Text("\(DateUtils.getDayOfWeek()) , \(DateUtils.getDate()) \(DateUtils.getMonth()) " )
                                    .font(.system(size: 12))
                                
                                
                            }
                            .foregroundStyle(.gray)
                        }
                        
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
                        .sheet(isPresented: $showTaskToggle){
                            AddingTask()
                                .environmentObject(taskViewModel)
                        }
                        
                        
                    }
                    .padding()
                    
                    
                    TaskDisplayView(tasks: $taskViewModel.tasks, openCount: taskViewModel.openTaskCount, doneCount: taskViewModel.doneTaskCount, archivedCount: taskViewModel.archivedTaskCount, allCount: taskViewModel.allTasks)
                        .environmentObject(taskViewModel)
                    
                    
                }
            }
        }
    }
    
}

//#Preview {
//    TaskView()
//}




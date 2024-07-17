//
//  AssignmentAddingTasks.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 22/06/24.
//

import SwiftUI


struct AssignmentAddingTasks: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var subTitle: String = ""

    @State private var deadline: Date = Date.now
    @State private var timeToComplete: Date = Date()
    
    
    @State private var status: TaskModel.TaskStatus = .open

    @EnvironmentObject var taskViewModel: TaskViewModel

    var assingmentId: String


    

    var body: some View {
        NavigationView {
            Form {
                TextField("Enter the task title", text: $title)
                TextField("Enter the task subtitle", text: $subTitle)

                
                
                DatePicker(selection: $deadline, in: Date.now..., displayedComponents: .date) {
                        Image(systemName: "calender")
                }
                
                
                
                DatePicker("Time to Complete", selection: $timeToComplete, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                
                
                
                
                Button("Submit"){
                    
                    

                    
                    Task{
                        try await taskViewModel.addTasks(assignmentId: assingmentId, title: title, subTitle:subTitle ,deadline: deadline , timeToComplete: timeToComplete, status: TaskModel.TaskStatus.open)
                        
                        await taskViewModel.fetchTasksByAssignment(assId: assingmentId)
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
                

            }
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitle("Add Course", displayMode: .inline)
        }
        .presentationDetents([.height(600)])
    }
}

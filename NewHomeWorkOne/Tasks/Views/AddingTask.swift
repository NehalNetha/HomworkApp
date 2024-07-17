//
//  AddingTask.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 03/07/24.
//

import SwiftUI

struct AddingTask: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var subTitle: String = ""

    @State private var deadline: Date = Date.now
    @State private var timeToComplete: Date = Date()
    @ObservedObject var assignViewModel =  AssignmentViewModel()
    
    @State private var selectedAss: AssignmentModel? = nil
    var date: Date?

    @EnvironmentObject var taskViewModel: TaskViewModel

    init(date: Date? = nil) {
            self.date = date
            _deadline = State(initialValue: date ?? Date.now)
    }

    

    var body: some View {
        NavigationView {
            Form {
                TextField("Enter the task title", text: $title)
                TextField("Enter the task subtitle", text: $subTitle)

                
                Picker("Assignment Name", selection: $selectedAss) {
                    ForEach(assignViewModel.assignments, id: \.self){ ass in
                        Text(ass.title).tag(ass as AssignmentModel?)
                        
                    }
                }
               
                
                
                if let date = date{
                    HStack {
                        Image(systemName: "calendar")
                        Text("Day: \(DateUtils.formattedDate(date))")
                    }
                }else{
                    
                    
                    DatePicker(selection: $deadline, in: Date.now..., displayedComponents: .date) {
                        Image(systemName: "calendar")
                    }
                    
                }
                
                DatePicker("Time to Complete", selection: $timeToComplete, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(WheelDatePickerStyle())
                    
            
                
                
                Button("Submit"){
                    
                    
                    guard let selectedAss = selectedAss else {
                       print("Select a ass")
                       return
                   }

                    
                    Task{
                        try await taskViewModel.addTasks(assignmentId: selectedAss.id ?? "", title: title, subTitle:subTitle ,deadline: deadline , timeToComplete: timeToComplete, status: TaskModel.TaskStatus.open)
                    }
                    
                    if let date = date{
                        Task{
                            await taskViewModel.fetchTasksByDate(date: date)
                        }
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
                

            }
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitle("Add Course", displayMode: .inline)
        }
    }
}


//
//  EditTaskView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 03/07/24.
//

import SwiftUI

struct EditTaskView: View {
    
    var id: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var subTitle: String = ""
    
    @State private var deadline: Date = Date.now
    @State private var timeToComplete: Date = Date()
    @ObservedObject var assignViewModel =  AssignmentViewModel()
    
    @State private var selectedAss: AssignmentModel? = nil
    

    @EnvironmentObject var taskViewModel: TaskViewModel


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
               
                
                DatePicker(selection: $deadline, in: Date.now..., displayedComponents: .date) {
                        Image(systemName: "calender")
                }
                
                
                
                DatePicker("Time to Complete", selection: $timeToComplete, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                
                
                
            
                
                
                Button("Submit"){
                    
                    
                    guard let selectedAss = selectedAss else {
                       print("Select a ass")
                       return
                   }

                    
                    Task{
                         await taskViewModel.UpdateTheTask(taskID: id, title: title, subTitle:subTitle ,deadline: deadline , timeToComplete: timeToComplete, assignmentId:  selectedAss.id ?? "")
                        
                        
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
                

            }
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitle("Editing Course", displayMode: .inline)
        }
    }
}

#Preview {
    EditTaskView(id: "afas")
}

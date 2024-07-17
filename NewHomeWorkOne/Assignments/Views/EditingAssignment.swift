//
//  EditingAssignment.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 24/06/24.
//

import SwiftUI

struct EditingAssignment: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var assignmentName: String = ""
    @State private var deadline: Date = Date.now
    @State private var selectedCourse: CourseModel? = nil
    var id: String
    @ObservedObject var courseViewModel = CourseViewModel()
    @EnvironmentObject var assignViewModel: AssignmentViewModel



    

    var body: some View {
        NavigationView {
            Form {
                TextField("Enter the assignment title", text: $assignmentName)
                    .foregroundStyle(.black)
                
                Picker("Course Name", selection: $selectedCourse) {
                    ForEach(courseViewModel.courses, id: \.self) { course in
                        Text(course.coursename).tag(course as CourseModel?)
                    }
                }
                .foregroundStyle(.black)

                
                DatePicker(selection: $deadline, in: Date.now..., displayedComponents: .date) {
                        Image(systemName: "calender")
                }
                
                Button("Edit"){
                    
                    
                    guard let selectedCourse = selectedCourse else {
                       print("Select a course")
                       return
                   }
                    print(selectedCourse)

                    
                    Task{
                        
                        try? await assignViewModel.updateAssignment(assignmentId: id, updatedTitle: assignmentName, updatedDeadline: deadline, updatedCourseUid: selectedCourse.id ?? "", updatedCourseName: selectedCourse.coursename)
                        
                    }
                    
                    print(deadline)

                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundStyle(.blue)
                

            }
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarTitle("Edit Course", displayMode: .inline)
        }
        .presentationDetents([.height(600)])
    }
}

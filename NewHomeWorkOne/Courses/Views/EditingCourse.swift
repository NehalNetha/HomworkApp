//
//  EditingCourse.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 29/06/24.
//

import SwiftUI

struct EditingCourse: View {
    @State private var courseName = ""
    @State private var courseDescription = ""
    var courseId: String
    @EnvironmentObject var courseViewModel : CourseViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            Form{
                TextField("Course Name", text: $courseName)
                
                TextField("Course Description", text: $courseDescription)
                
                Button{
                    Task{
                        await courseViewModel.updateCourse(courseName: courseName, courseDescription: courseDescription,courseId: courseId)
                    }
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Text("Submit")
                }
            }
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    EditingCourse(courseId: "asfasfasf")
}

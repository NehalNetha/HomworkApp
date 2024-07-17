//
//  AddAssignment.swift
//  HomeworkApp
//
//  Created by NehalNetha on 09/06/24.
//

import SwiftUI

struct AddCourse: View {
    
    @State private var showHalfSheet = false
    @ObservedObject var courseViewModel = CourseViewModel()
    @EnvironmentObject var assingmentViewModel: AssignmentViewModel

    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    VStack(alignment: .leading){
                        Text("Course")
                            .font(.system(size: 26))
                            .fontWeight(.semibold)
                        Text("you have 3 assignments")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    
                    Button{
                        showHalfSheet.toggle()
                    }label: {
                        HStack{
                            Image(systemName: "plus")
                                .foregroundStyle(Color(hex: "1758D6"))

                            Text("Add")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(hex: "1758D6"))
                            
                           
                        }
                        .padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13 ))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color(hex: "ACD2FF"))
                        )
                        
                    }
                    .sheet(isPresented: $showHalfSheet){
                        HalfSheetView()
                            .environmentObject(courseViewModel)
                    }
                    
                    
                }
                .padding()
                
                if courseViewModel.courses.count != 0 {
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 18){
                            
                            ForEach(courseViewModel.courses){course in
                                
                                NavigationLink{
                                    CourseEdit( Course: course)
                                        .environmentObject(courseViewModel)
                                        .environmentObject(assingmentViewModel)
                                }label: {
                                    
                                    CoureBlock(courseName: course.coursename, courseDescription: course.courseDescription)
                                }
                                
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                }else{
                    HStack{
                        DefaultCourseBlock()
                            .environmentObject(courseViewModel)
                            .padding(.leading)
                        
                        Spacer()
                    }
                }

            }
            
        }
    }
}



struct HalfSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var courseName: String = ""
    @State private var courseDescription: String = ""
    @EnvironmentObject var courseViewModel: CourseViewModel
    @StateObject var authViewModel = AuthViewModel()
    


    

    var body: some View {
        NavigationView {
            Form {
                TextField("Enter the course name", text: $courseName)
                TextField("Enter the course description", text: $courseDescription)
                
                
                Button("Submit"){
                    
                  
                    courseViewModel.addCourse(courseName: courseName, courseDescription: courseDescription)
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

#Preview {
    AddCourse()
}

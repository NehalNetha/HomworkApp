

import SwiftUI

struct AddAssignments: View {
    @State private var showAddAss = false
    @EnvironmentObject var assignViewModel: AssignmentViewModel

    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                HStack{
                    VStack(alignment: .leading){
                        Text("Assignments")
                            .font(.system(size: 26))
                            .fontWeight(.semibold)
                        Text("you have 4 assignments")
                            .foregroundStyle(.gray)
                            .font(.system(size: 12))
                    }
                    
                    Spacer()
                    Button{
                        showAddAss.toggle()
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
                    .sheet(isPresented: $showAddAss){
                        AddingAssignments()
                            .environmentObject(assignViewModel)
                    }
                    
                    
                }
                .padding()
                
                if assignViewModel.assignments.count != 0 {
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 18){
                            
                            
                            ForEach(assignViewModel.assignments){ass in
                                NavigationLink{
                                    AssignmentEdit(ass: ass)
                                        .environmentObject(assignViewModel)
                                }label: {
                                    BlockAssignment(assignmentTitle: ass.title, courseName: ass.courseName, deadlineDate: ass.deadline, assId: ass.id ?? "")
                                        .environmentObject(assignViewModel)
                                }
                                
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                }else{
                    HStack{
                        DefaultAssignmentBlock()
                            .environmentObject(assignViewModel)
                            .padding(.leading)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

struct AddingAssignments: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var assignmentName: String = ""
    @State private var deadline: Date = Date.now
    @State private var selectedCourse: CourseModel? = nil
    @ObservedObject var courseViewModel = CourseViewModel()
    @EnvironmentObject var assignViewModel: AssignmentViewModel



    

    var body: some View {
        NavigationView {
            Form {
                TextField("Enter the assignment title", text: $assignmentName)
                
                Picker("Course Name", selection: $selectedCourse) {
                    ForEach(courseViewModel.courses, id: \.self) { course in
                        Text(course.coursename).tag(course as CourseModel?)
                    }
                }
                
                DatePicker(selection: $deadline, in: Date.now..., displayedComponents: .date) {
                        Image(systemName: "calender")
                }
                
                
            
                
                
                Button("Submit"){
                    
                    
                    guard let selectedCourse = selectedCourse else {
                       print("Select a course")
                       return
                   }
                    print(selectedCourse)

                    print(deadline)
                    
                    
                    assignViewModel.addAssignments(title: assignmentName, deadline: deadline, couseUid: selectedCourse.id ?? "", courseName: selectedCourse.coursename )
                    
                    
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
    AddAssignments()
}

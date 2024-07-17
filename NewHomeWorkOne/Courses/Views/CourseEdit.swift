//
//  CourseEdit.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 27/06/24.
//

import SwiftUI

struct CourseEdit: View {
    @EnvironmentObject var courseViewModel: CourseViewModel
    @EnvironmentObject var assignmentViewModel : AssignmentViewModel
    var Course: CourseModel
    var body: some View {
        NavigationStack{
            ZStack{
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading){
                    TopZStackCourse()
                    
                    VStack(alignment: .leading){
                        Text("Assignments")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                    }
                    .padding(.leading)

                    
                    
                    AssignmentScroll()
                    
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
                .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear{
                Task{
                    await assignmentViewModel.fetchAssingmentsByID(courseID: Course.id ?? "")
                }
                assignmentViewModel.updateCountOfAss()
            }
        }
    }
}


extension CourseEdit{
    private func AssignmentScroll() -> some View{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10){
                    ForEach(assignmentViewModel.assignmentsByCourse){ass in
                        CourseAssignmentBlock(assignmentTitle: ass.title, courseName: "asfa", deadlineDate: ass.deadline, assId: ass.id)
                            .environmentObject(assignmentViewModel)
                    }
                }
            }
            .frame(maxWidth: .infinity)  // Center the VStack contents


    }
}

extension CourseEdit{
    private func TopZStackCourse() -> some View{
        ZStack{
            Image("CustomCurveTwo")
                .resizable()
            
            VStack{
                TopNav(courseId: Course.id ?? "")
                    .environmentObject(courseViewModel)
                VStack(alignment: .leading){
                    HStack{
                        Text(Course.coursename)
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                            .padding()
                        
                        Spacer()
                    }
                    

                    
                    VStack{
                        Text("You have  \(assignmentViewModel.assignmentCountByCourse) 10 assignments")
                            .foregroundStyle(.white)
                            .font(.title2)
                    }
                    .padding(.leading)
                    
                    
                    HStack{
                        Spacer()
                        Image(systemName: "calendar")
                        Text(DateUtils.formattedDate(Date()))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .foregroundStyle(.white)
                }
                
            }
        }
        .frame(height: 340)

    }
}




#Preview {
    CourseEdit( Course: CourseModel(id: "asasf", coursename: "gasfa", courseDescription: "asasfas", uid: "asfaf"))
}

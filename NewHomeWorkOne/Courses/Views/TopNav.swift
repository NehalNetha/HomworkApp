//
//  TopNav.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 28/06/24.
//

import SwiftUI



struct TopNav: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showCourseAss = false
    @EnvironmentObject var courseViewModel: CourseViewModel
    @State private var showCalendar = false
    @State private var selectedDate = Date()
    var courseId: String


    var body: some View {
        HStack{
            Button{
                presentationMode.wrappedValue.dismiss()
            }label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15))
                    .padding()
                    .background(
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    )
            }
            Spacer()
            Button{
                showCourseAss.toggle()
            }label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 15))
                    .padding()
                    .background(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
            .sheet(isPresented: $showCourseAss){
                EditingCourse(courseId: courseId)
                    .environmentObject(courseViewModel)
            }
            
        }
        .padding()
        .foregroundStyle(.white)
    }
}

#Preview {
    TopNav(courseId: "asfasf")
}

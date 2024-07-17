//
//  HomeView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 17/06/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var assignmentViewModel = AssignmentViewModel()
    @EnvironmentObject var taskViewModel : TaskViewModel
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack {
                    NavbarView()
                    VStack{
                        AddCourse()
                            .environmentObject(assignmentViewModel)
                            .frame(height: 200)
                        AddAssignments()
                            .environmentObject(assignmentViewModel)

                        TaskView()
                            .environmentObject(taskViewModel)

                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

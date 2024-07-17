//
//  MainTabView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 14/06/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewMode: AuthViewModel
    @ObservedObject var taskViewModel = TaskViewModel()
    var body: some View {
        TabView{
            HomeView()
                .environmentObject(taskViewModel)
                .tabItem {
                    Image(systemName: "house")
                }
            
            CalendarView()
                .environmentObject(taskViewModel)
                .tabItem {
                    Image(systemName: "calendar")

                }
            
            NotificationView()
                .tabItem{
                    Image(systemName: "bell")
                }
            
            ProfileView()
                .environmentObject(authViewMode)
                .tabItem {
                    Image(systemName: "person")
                }
            
            
        }
    }
}

#Preview {
    MainTabView()
}

//
//  CalendarTaskViewModel.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 01/07/24.
//

import Foundation
//
//  TaskViewModel.swift
//  CalenderThing
//
//  Created by NehalNetha on 01/07/24.
//

import Foundation
import SwiftUI
//
//struct Task: Identifiable{
//    var id = UUID().uuidString
//    var taskname: String
//    var taskDescription: String
//    var taskDate: Date
//}

class CalendarTaskViewModel: ObservableObject{
    
    
    
    @Published var storedTasks: [TaskModel] = [
    
        TaskModel(id: UUID().uuidString, assignmentId: "324324", userId: "sfgsdg", title: "what the heck", subTitle: "omg", deadline: Date(), timeToComplete: Date()),
        TaskModel(id: UUID().uuidString, assignmentId: "324324", userId: "user1", title: "Meeting", subTitle: "Discuss project", deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, timeToComplete: Date()),
        TaskModel(id: UUID().uuidString, assignmentId: "234234", userId: "user1", title: "And alot ", subTitle: "Discuss project", deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, timeToComplete: Date()),
        TaskModel(id: UUID().uuidString, assignmentId: "234234", userId: "user1", title: "Chairs", subTitle: "Discuss project", deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, timeToComplete: Date()),
        TaskModel(id: UUID().uuidString, assignmentId: "23453", userId: "user1", title: "Curtains", subTitle: "Discuss project", deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, timeToComplete: Date()),
        TaskModel(id: UUID().uuidString, assignmentId: "23757", userId: "user1", title: "Carrom Board", subTitle: "Discuss project", deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, timeToComplete: Date()),
        TaskModel(id: UUID().uuidString, assignmentId: "121231", userId: "user1", title: "Shit", subTitle: "Discuss project", deadline: Calendar.current.date(byAdding: .day, value: 4, to: Date())!, timeToComplete: Date()),
        TaskModel(id: UUID().uuidString, assignmentId: "3243252324", userId: "user1", title: "Watever", subTitle: "Discuss project", deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date())!, timeToComplete: Date()),
        TaskModel(id: UUID().uuidString, assignmentId: "3243252324", userId: "user1", title: "Watever", subTitle: "Discuss project", deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date())!, timeToComplete: Date()),
    ]
    
    @Published var currentWeek : [Date] = []
    @Published var currentDate : Date = Date()
    @Published var filteredTasks: [TaskModel]?
    private var weekOffset: Int = 0

    
    
    init(){
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    func filterTodayTasks() {
        
        DispatchQueue.global(qos: .userInteractive).async{
            
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter{
                return calendar.isDate($0.deadline , inSameDayAs: self.currentDate)
            }
            
            DispatchQueue.main.async{
                withAnimation{
                    self.filteredTasks = filtered
                    
                }
            }
        }
    }
    
 
    func fetchCurrentWeek(offset: Int = 0) {
        currentWeek.removeAll()
        
        let today = Date()
        let calendar = Calendar.current
        
        guard let week = calendar.dateInterval(of: .weekOfMonth, for: calendar.date(byAdding: .weekOfMonth, value: offset, to: today)!) else {
            return
        }
        
        let firstWeek = week.start
        
        (0..<7).forEach { day in
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeek) {
                currentWeek.append(weekDay)
            }
        }
    }
                
    func loadNextWeek() {
        weekOffset += 1
        fetchCurrentWeek(offset: weekOffset)
    }
    
    
    func loadPrevWeek() {
        weekOffset -= 1
        fetchCurrentWeek(offset: weekOffset)
    }
            
    
    func extractDate(date: Date, format: String) -> String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
}


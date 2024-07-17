//
//  TaskViewModel.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 18/06/24.
//

import Foundation
import Firebase
import FirebaseFirestore

@MainActor
class TaskViewModel: ObservableObject{
    @Published var tasks: [TaskModel] = []
    @Published var taskByStatus: [TaskModel] = []
    @Published var taskByAss: [TaskModel] = []
    private var db = Firestore.firestore()
    private var assignViewModel = AssignmentViewModel()
    
    
    @Published var taskByDate: [TaskModel] = []

    @Published var allTasks: Int = 0
    @Published var openTaskCount: Int = 0
    @Published var doneTaskCount: Int = 0
    @Published var archivedTaskCount: Int = 0
    
    @Published var allTasksAss: Int = 0
    @Published var openTaskCountAss: Int = 0
    @Published var doneTaskCountAss: Int = 0
    @Published var archivedTaskCountAss: Int = 0
    
    private let debouncer = Debouncer(delay: 1.0)

    
    
    
    
    init() {
        Task{
            await fetchTask()
            await fetchTasksByDate(date: Date())
        }
    }

    
    func toggleStatusTask(taskID: String, isChecked: Bool) {
        Task { @MainActor in
            if let indexAss = taskByAss.firstIndex(where: {$0.id == taskID}) {
                taskByAss[indexAss].status = isChecked ? .Done : .open
                updateTasksCountByAss()
            }
            if let index = tasks.firstIndex(where: {$0.id == taskID}) {
                tasks[index].status = isChecked ? .Done : .open
                updateTasksCount()
                updateTasksCountByAss()
                
                let newStatus = tasks[index].status
                
                debouncer.call {
                    Task {
                        await self.updateTaskInDatabase(taskId: taskID, status: newStatus)
                    }
                }
            }
        }
        
    }
    
    func updateTaskInDatabase(taskId: String, status: TaskModel.TaskStatus) async {
        do {
            try await db.collection("tasks").document(taskId).updateData(["status": status.rawValue])
            print("Task updated successfully")
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }
    
    func addTasks(assignmentId: String, title: String, subTitle: String, deadline: Date, timeToComplete: Date, status: TaskModel.TaskStatus = .open) async throws
    {
        
        guard let userUid = Auth.auth().currentUser?.uid else { return  }
        let newTask = TaskModel(assignmentId: assignmentId, userId: userUid, title: title, subTitle: subTitle, deadline: deadline, timeToComplete: timeToComplete, status: status)
        
        do{
            let encodedTask = try Firestore.Encoder().encode(newTask)
                
            try await db.collection("tasks").document().setData(encodedTask){ [self]error in
                if let error = error{
                    print("Error adding assignments: \(error.localizedDescription)")

                }else{
                    Task{
                        await assignViewModel.fetchAssignments()
                        await fetchTask()
                    }
                    print("Assignments added successfully")

                }
            }

        }catch{
            print("Error adding task to assignment: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchTask() async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let snapshot = try? await Firestore.firestore().collection("tasks")
            .whereField("userId", isEqualTo: uid)
            .getDocuments()
        
        let fetchedTasks = try await snapshot?.documents.compactMap { try? $0.data(as: TaskModel.self) } ?? []

        DispatchQueue.main.async {
            self.tasks = fetchedTasks
            self.updateTasksCount()

        }
    }
    
    func fetchTaskByStatus(status: TaskModel.TaskStatus? = nil) async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var query = Firestore.firestore().collection("tasks")
            .whereField("userID", isEqualTo: uid)
        
        if let status = status{
            query = query.whereField("status", isEqualTo: status.rawValue)
        }
        
        let snapshot = try? await query.getDocuments()
        
        let fetchedTasks = snapshot?.documents.compactMap{try? $0.data(as: TaskModel.self)} ?? []
        
        DispatchQueue.main.async{
            self.taskByStatus = fetchedTasks
        }
        
    }
    
    func fetchTasksByAssignment(assId: String) async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = Firestore.firestore().collection("tasks")
            .whereField("userId", isEqualTo: uid)
            .whereField("assignmentId", isEqualTo: assId)
        
        let snapshot = try? await query.getDocuments()
        let fetchedTasks = snapshot?.documents.compactMap{try? $0.data(as: TaskModel.self)} ?? []
        
        DispatchQueue.main.async{
            self.taskByAss = fetchedTasks
            self.updateTasksCountByAss()
        }
        
        print(self.taskByAss)
    }
    
    func fetchTasksByDate(date: Date) async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            // Create date range for the entire day
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            let query = Firestore.firestore().collection("tasks")
                .whereField("userId", isEqualTo: uid)
                .whereField("deadline", isGreaterThanOrEqualTo: startOfDay)
                .whereField("deadline", isLessThan: endOfDay)
            
            do {
                let snapshot = try await query.getDocuments()
                let fetchedTasks = snapshot.documents.compactMap { try? $0.data(as: TaskModel.self) }
                
                await MainActor.run {
                    self.taskByDate = fetchedTasks
                    self.updateTasksCount()
                }
                print(taskByDate)
                print("Fetched \(fetchedTasks.count) tasks for \(date)")
            } catch {
                print("Error fetching tasks by date: \(error.localizedDescription)")
            }
    }
    
    func deleteTask(taskId: String) async throws {
        
        do {
            try await db.collection("tasks").document(taskId).delete()
            
            await MainActor.run  {
                self.tasks.removeAll { $0.id == taskId }
                self.updateTasksCount()
                self.updateTasksCountByAss()
            }
            
            await fetchTask()
            await assignViewModel.fetchAssignments()
        
        } catch {

            print("Error deleting task: \(error.localizedDescription)")
            throw error
            
        }
    }
    
    func updateTaskToArchive(taskID: String) async throws {
        do {
            try await db.collection("tasks").document(taskID).updateData(["status": TaskModel.TaskStatus.archived.rawValue])
            
            DispatchQueue.main.async {
                if let index = self.tasks.firstIndex(where: { $0.id == taskID }) {
                    self.tasks[index].status = .archived
                    self.updateTasksCount()
                }
            }
            
            print("Task archived successfully")
        } catch {
            print("Error archiving task: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateTaskToDone(taskId: String) async throws{
        do{
            try await db.collection("tasks").document(taskId).updateData(["status": TaskModel.TaskStatus.Done.rawValue])
            
            DispatchQueue.main.async {
                if let index = self.tasks.firstIndex(where: { $0.id == taskId }) {
                    self.tasks[index].status = .Done
                    self.updateTasksCount()
                }
            }
            print("Task done successfully")

        }catch{
            
                print("Error archiving task: \(error.localizedDescription)")
                throw error
        }
        
    }

    
    func UpdateTheTask(taskID: String, title: String, subTitle: String, deadline: Date, timeToComplete: Date, assignmentId: String,  status: TaskModel.TaskStatus = .open) async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let updatedTask = TaskModel(assignmentId: assignmentId, userId: uid, title: title, subTitle: subTitle, deadline: deadline, timeToComplete: timeToComplete, status: status)
        let taskRef = db.collection("tasks").document(taskID)
        do{
            try await taskRef.updateData([
                "assignmentId": updatedTask.assignmentId,
                "userId": updatedTask.userId,
                "title": updatedTask.title,
                "subTitle": updatedTask.subTitle,
                "deadline": updatedTask.deadline,
                "timeToComplete": updatedTask.timeToComplete,
                "status": updatedTask.status.rawValue
                
            ])
            
            
            Task{
                await fetchTask()
                await fetchTasksByDate(date: Date())
            }
            print("Course updated successfully")
        }catch{
            print("error happend while updating the assignment \(error.localizedDescription)")

        }
    }
    
    
    func updateTasksCount(){
        self.allTasks = self.tasks.count
        self.openTaskCount = self.tasks.filter { $0.status == .open}.count
        self.doneTaskCount = self.tasks.filter { $0.status == .Done }.count
        self.archivedTaskCount = self.tasks.filter { $0.status == .archived }.count
    }
    
    
    func updateTasksCountByAss(){
        self.allTasksAss = self.taskByAss.count
        self.openTaskCountAss = self.taskByAss.filter { $0.status == .open}.count
        self.doneTaskCountAss = self.taskByAss.filter { $0.status == .Done }.count
        self.archivedTaskCountAss = self.taskByAss.filter { $0.status == .archived }.count
    }

    
}

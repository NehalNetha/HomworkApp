//
//  AssignmentViewModel.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 14/06/24.
//

import Foundation
import Firebase

@MainActor
class AssignmentViewModel: ObservableObject{
    @Published var assignments: [AssignmentModel] = []
    @Published var assignmentsByCourse: [AssignmentModel] = []
    private var db = Firestore.firestore()
    
    @Published var assignmentCountByCourse = 0
    
    init(){
        Task{
            await fetchAssignments()
        }
    }

    
    
    func addAssignments(title: String, deadline: Date, couseUid: String, courseName: String){
        guard let userUid = Auth.auth().currentUser?.uid else {return}
        let newAssignment = AssignmentModel(title: title, courseUid: couseUid, courseName: courseName, deadline: deadline, userUid: userUid)
        
        do{
            let encodedAss = try Firestore.Encoder().encode(newAssignment)
            db.collection("assignments").document().setData(encodedAss){ [self]error in
                if let error = error{
                    print("Error adding assignments: \(error.localizedDescription)")

                }else{
                    Task{
                       await fetchAssignments()
                    }
                    self.updateCountOfAss()
                    print("Assignments added successfully")

                }
            }
        }catch{
            print("Error encoding course: \(error.localizedDescription)")

        }
    }
    
    func fetchAssignments() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            return
        }

        do {
            let snapshot = try await Firestore.firestore().collection("assignments")
                .whereField("userUid", isEqualTo: uid)
                .getDocuments()
            
            let fetchedAssignments = snapshot.documents.compactMap { document -> AssignmentModel? in
                do {
                    return try document.data(as: AssignmentModel.self)
                } catch {
                    print("Error decoding assignment document: \(error)")
                    return nil
                }
            }
            
            await MainActor.run {
                self.assignments = fetchedAssignments
                if fetchedAssignments.isEmpty {
                    print("No assignments found")
                }
                self.updateCountOfAss()
            }
        } catch {
            print("Failed to fetch assignments: \(error.localizedDescription)")
        }
    }
    
    
    func fetchAssingmentsByID(courseID: String) async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        do{
            let snapshot = try await Firestore.firestore().collection("assignments")
                .whereField("userUid", isEqualTo: uid )
                .whereField("courseUid", isEqualTo: courseID)
                .getDocuments()
            
            
            let fetchedAssignments = snapshot.documents.compactMap { try? $0.data(as: AssignmentModel.self) }
            
            DispatchQueue.main.async{
                self.assignmentsByCourse = fetchedAssignments
            }

            print("Assignments for course \(courseID) fetched successfully")

            
        }catch{
            print("cant fetch assignments by Id \(error.localizedDescription)")
        }
        
        
    }
    
    func deleteAssignment(assignmentId: String) async throws {
        do {
            try await db.collection("assignments").document(assignmentId).delete()
            
            await MainActor.run {
                self.assignments.removeAll { $0.id == assignmentId }
                self.assignmentsByCourse.removeAll() {$0.id == assignmentId}
            }
            
            await fetchAssignments()
            self.updateCountOfAss()
            print("Assignment deleted successfully")
        } catch {
            print("Error deleting assignment: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateAssignment(assignmentId: String, updatedTitle: String, updatedDeadline: Date, updatedCourseUid: String, updatedCourseName: String) async throws {
        guard let userUid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "UpdateAssignmentError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let updatedAssignment = AssignmentModel(id: assignmentId, title: updatedTitle, courseUid: updatedCourseUid, courseName: updatedCourseName, deadline: updatedDeadline, userUid: userUid)
        
        do {
            let encodedAssignment = try Firestore.Encoder().encode(updatedAssignment)
            try await db.collection("assignments").document(assignmentId).setData(encodedAssignment)
            
            await fetchAssignments()
            print("Assignment updated successfully")
        } catch {
            print("Error updating assignment: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateAssignmentDeadline(assignmentId: String, deadline: Date) async{
        guard let userUid = Auth.auth().currentUser?.uid else {return}
        do{
            try await db.collection("assignments").document(assignmentId).updateData([
                "deadline": deadline
            ])
            await fetchAssignments()
            print("Assignment deadline updated successfully")
        }catch{
            print("Error updating assignment deadline: \(error.localizedDescription)")
        }
    }
    
    func updateCountOfAss() {
        self.assignmentCountByCourse = assignmentsByCourse.count
    }
}

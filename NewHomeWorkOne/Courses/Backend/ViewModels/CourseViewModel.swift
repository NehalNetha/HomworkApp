//
//  CourseViewModel.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 14/06/24.
//

import Foundation
import FirebaseFirestore
import Firebase

class CourseViewModel: ObservableObject{
    @Published var courses: [CourseModel] = []
    private var db = Firestore.firestore()
    @Published var error: String?
    
    
    
    
    init()   {
        
        Task{
            await fetchCourses()
        }
        print(courses)
    }
    
    
    
   
    
    func addCourse(courseName: String, courseDescription: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let newCourse = CourseModel(coursename: courseName, courseDescription: courseDescription, uid: uid)
        
        do{
            let encodedCourse = try Firestore.Encoder().encode(newCourse)
            db.collection("courses").document().setData(encodedCourse){ [self]error in
                if let error = error {
                    print("Error adding course: \(error.localizedDescription)")
                } else {
                    print("Course added successfully")
                    Task{
                        await fetchCourses()
                    }
                }
            }
        }catch{
            print("Error encoding course: \(error.localizedDescription)")
        }
    }
    
    func fetchCourses() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            await MainActor.run {
                self.error = "No authenticated user found"
            }
            return
        }

        do {
            let snapshot = try await Firestore.firestore().collection("courses")
                .whereField("uid", isEqualTo: uid)
                .getDocuments()
            
            let fetchedCourses = snapshot.documents.compactMap { document -> CourseModel? in
                do {
                    return try document.data(as: CourseModel.self)
                } catch {
                    print("Error decoding course document: \(error)")
                    return nil
                }
            }
            
            await MainActor.run {
                self.courses = fetchedCourses
                if fetchedCourses.isEmpty {
                    self.error = "No courses found"
                } else {
                    self.error = nil
                }
            }
        } catch {
            await MainActor.run {
                self.error = "Failed to fetch courses: \(error.localizedDescription)"
            }
        }
    }
    
    func updateCourse(courseName: String, courseDescription: String, courseId: String) async{
       
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let updateCourse =  CourseModel(coursename: courseName, courseDescription: courseDescription, uid: uid)
        let courseRef = db.collection("courses").document(courseId)
        
        do{
            try await courseRef.updateData([
                "coursename": updateCourse.coursename,
                "courseDescription": updateCourse.courseDescription,
                "uid": uid
            ])
            
            Task{
                await fetchCourses()
            }
            print("Course updated successfully")

        }catch{
            print("error happend while updating the coure \(error.localizedDescription)")
        }
    }
    
    
}

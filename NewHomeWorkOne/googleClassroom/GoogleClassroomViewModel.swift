//
//  GoogleClassroomViewModel.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 17/07/24.
//

import Foundation

class GoogleClassroomViewModel: ObservableObject{
    
    @Published var courses: [Course] = []
    
    func fetchGoogleClassroomCourses() {
        Task {
            
            do {
                self.courses = try await GoogleClassroomService.shared.fetchCourses()
            } catch {
                print("\(error.localizedDescription)")
            }
            
        }
    }
}

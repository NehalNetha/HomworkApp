//
//  TaskModel.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 18/06/24.
//

import Foundation
import FirebaseFirestoreSwift

struct TaskModel: Identifiable, Codable, Hashable{
    @DocumentID var id : String?
    let assignmentId: String
    let userId: String
    let title: String
    let subTitle: String
    var deadline: Date
    var timeToComplete: Date
    var status: TaskStatus = .open
    
    enum TaskStatus: String, Codable{
        case open
        case Done
        case archived

    }
}

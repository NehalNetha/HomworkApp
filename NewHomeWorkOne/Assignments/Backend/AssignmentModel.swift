//
//  AssignmentModel.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 14/06/24.
//

import Foundation
import FirebaseFirestoreSwift


struct AssignmentModel: Identifiable, Codable, Hashable{
    
    @DocumentID var id: String?
    let title: String
    let courseUid: String
    let courseName: String
    let deadline: Date
    let userUid: String

}


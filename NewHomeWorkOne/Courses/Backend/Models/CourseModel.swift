//
//  CourseModel.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 14/06/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct CourseModel: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    let coursename: String
    let courseDescription: String
    let uid: String
    
    
  
}


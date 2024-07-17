import Foundation
import GoogleSignIn

class GoogleClassroomService {
    static let shared = GoogleClassroomService()
    
    private init() {}
    
    func fetchCourses() async throws -> [Course] {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No signed-in user"])
        }
        
        let urlString = "https://classroom.googleapis.com/v1/courses"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Get the access token
        let accessToken = try await user.accessToken.tokenString
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let courseList = try JSONDecoder().decode(CourseList.self, from: data)
        return courseList.courses
    }
}

struct CourseList: Codable {
    let courses: [Course]
}

struct Course: Codable, Identifiable {
    let id: String
    let name: String
    let section: String?
    let descriptionHeading: String?
    let room: String?
}

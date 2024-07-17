import SwiftUI

struct Classroom: View {
    @StateObject var googleClassroomViewModel = GoogleClassroomViewModel()
    var body: some View {
        NavigationView {
            Group {
               
                    List(googleClassroomViewModel.courses) { course in
                        VStack(alignment: .leading) {
                            Text(course.name)
                                .font(.headline)
                            if let section = course.section {
                                Text("Section: \(section)")
                                    .font(.subheadline)
                            }
                            if let room = course.room {
                                Text("Room: \(room)")
                                    .font(.subheadline)
                            }
                        }
                    }
            }
            .navigationTitle("Google Classroom Courses")
        }
        .onAppear {
            Task {
                await googleClassroomViewModel.fetchGoogleClassroomCourses()
            }
        }
    }
}

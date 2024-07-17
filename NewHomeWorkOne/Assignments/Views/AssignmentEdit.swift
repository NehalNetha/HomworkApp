//
//  AssignmentEdit.swift
//  HomeworkApp
//
//  Created by NehalNetha on 09/06/24.
//

import SwiftUI

struct AssignmentEdit: View {
    @State var ass: AssignmentModel
    @EnvironmentObject var assignmentViewModel: AssignmentViewModel
    @StateObject var taskViewModel = TaskViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                ZStack{
                    Image("CustomCurveOne")
                        .resizable()
                    VStack{
                        TopNavView(ass: $ass)
                            .environmentObject(assignmentViewModel)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text(ass.title)
                                    .font(.system(size: 30))
                                    .foregroundStyle(.white)
                                    .padding()
                                
                                Spacer()
                            }
                            
                            VStack{
                                HStack{
                                    Text("Progress")
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Text("54%")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 15))
                                }
                                
                                ProgressBar(progress: 0.5, numberOfBlocks: 5, blockColor: .white, widthBlock: 60)
                            }
                            .padding()
                            
                            HStack{
                                Spacer()
                                Image(systemName: "calendar")
                                Text(DateUtils.formattedDate(ass.deadline))
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                }
                
                
                AssignmentTaskView(ass: $ass)
                    .environmentObject(taskViewModel)
                
                
                
            }
            .ignoresSafeArea(.all, edges: .top)

        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await taskViewModel.fetchTasksByAssignment(assId: ass.id ?? "")
            }
        }
    }
    
    func getDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Format for getting the day of the week
        return dateFormatter.string(from: Date())
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // Format for getting the day of the month
        return dateFormatter.string(from: Date())
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Format for getting the month
        return dateFormatter.string(from: Date())
    }
}



#Preview {
    AssignmentEdit(ass: AssignmentModel(title: "random", courseUid: "23", courseName: "courseRandom", deadline: Date(), userUid: "2323"))
    
}


struct TopNavView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var ass: AssignmentModel
    @State private var showEditAss = false
    @EnvironmentObject var assignViewModel: AssignmentViewModel
    @State private var showCalendar = false
    @State private var selectedDate = Date()


    var body: some View {
        HStack{
            Button{
                presentationMode.wrappedValue.dismiss()
            }label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .padding()
                    .background(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
            Spacer()
            Button{
                showCalendar.toggle()
            }label: {
                Image(systemName: "calendar")
                    .font(.title2)
                    .padding()
                    .background(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
            .sheet(isPresented: $showCalendar) {
                CalendarSheetView(ass: ass)
                    .environmentObject(assignViewModel)
            }
            Button{
                showEditAss.toggle()
            }label: {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                    .padding()
                    .background(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
            .sheet(isPresented: $showEditAss){
                EditingAssignment(id: ass.id ?? "")
                    .environmentObject(assignViewModel)
            }
            
        }
        .padding()
        .foregroundStyle(.white)
    }
}

struct CalendarSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @EnvironmentObject var assignViewModel: AssignmentViewModel
    var ass: AssignmentModel
    
    init(ass: AssignmentModel) {
        self.ass = ass
        _selectedDate = State(initialValue: ass.deadline)
    }

    var body: some View {
        NavigationView {
            VStack{
                DatePicker("Select a date", selection: $selectedDate, in: Date.now...,displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .navigationTitle("Calendar")
                    .navigationBarItems(trailing: Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    })
            
                Button{
                    Task{
                        await assignViewModel.updateAssignmentDeadline(assignmentId: ass.id ?? "", deadline: selectedDate)
                    }
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Text("Done")
                        .foregroundStyle(.white)
                }
                .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "3E6EE8"))
                )
            }
        }
    }
}




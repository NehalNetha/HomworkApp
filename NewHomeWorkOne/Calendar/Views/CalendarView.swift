


import SwiftUI



struct CalendarView: View {
    
    @StateObject var calendarTaskViewModel = CalendarTaskViewModel()
    @EnvironmentObject var taskViewModel : TaskViewModel
    @State private var tasksLoaded = false
    @State private var isChecked = false
    @Environment(\.editMode)  var editButton
    @State private var isSheetOpen = false
    @State private var isSheetAddTaskOpen = false
    @State private var increPrevWeek = 0
    @State private var increNextWeek = 0
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]){
                Section{
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 10){
                            Button{
                                calendarTaskViewModel.loadPrevWeek()
                                increPrevWeek += 1
                                if increNextWeek != 0{
                                    increNextWeek -= 1
                                }
                                increNextWeek = max(0, increNextWeek - 1)
                            }label: {

                                VStack(spacing: 10){
                                    
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .disabled(increPrevWeek >= 2 && increNextWeek == 0)

                            ForEach(calendarTaskViewModel.currentWeek, id: \.self){ day in
                                
                                VStack(spacing: 10){
                                    
                                    Text(calendarTaskViewModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Text(calendarTaskViewModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(calendarTaskViewModel.isToday(date: day) ? 1 : 0)
                                }
                                .foregroundStyle(calendarTaskViewModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundStyle(calendarTaskViewModel.isToday(date: day) ? .white : .black)
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack{
                                        
                                        if calendarTaskViewModel.isToday(date: day){
                                            
                                            Capsule()
                                                .fill(Color(hex: "050C9C"))
                                            //                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                        
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation{
                                        calendarTaskViewModel.currentDate = day
                                    }
                                }
                                .onAppear{
                                    loadTasks()
                                }
                            }
                            
                            
                            Button{
                                calendarTaskViewModel.loadNextWeek()
                                
                                increNextWeek += 1
                                increPrevWeek = max(0, increPrevWeek - 1)
                            }label: {

                                VStack(spacing: 10){
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .disabled(increNextWeek >= 2)

                            
                           
                            
                        }
                        .padding(.horizontal)
                        
                        
                    }
                    
                    if tasksLoaded{
                        TasksView()
                    }else{
                        ProgressView()
                    }

                    
                }header: {
                    HeaderView()
                }
            }
        }
        .overlay(
            Button{
                isSheetAddTaskOpen.toggle()
                
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color(hex: "050C9C"), in: Circle())

            }
                .padding()
                .sheet(isPresented: $isSheetAddTaskOpen){
                    AddingTask(date: calendarTaskViewModel.currentDate)
                        .environmentObject(taskViewModel)
                }
            ,alignment: .bottomTrailing
        )
    }
    
    private func loadTasks() {
          Task {
              await taskViewModel.fetchTasksByDate(date: calendarTaskViewModel.currentDate)
              tasksLoaded = true
          }
      }
    
    func HeaderView() -> some View{
        HStack(spacing: 10){
            VStack{
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.gray)

                Text("Today")
                    .font(.largeTitle.bold())
                
            }
            .hleading()
            
            Spacer()
            
            EditButton()
        }
        .padding()
    }
    
    func TasksView() -> some View {
       // This will be the persistent background
            
        LazyVStack(spacing: 18) {
            if taskViewModel.taskByDate.isEmpty {
                        Text("No Tasks Found")
                            .font(.system(size: 16))
                            .fontWeight(.light)
                            .offset(y: 100)
            } else {
                ForEach(taskViewModel.taskByDate) { task in
                    TaskCardView(task: task)
                }
            }
            }
            .onChange(of: calendarTaskViewModel.currentDate){
                Task{
                    await taskViewModel.fetchTasksByDate(date: calendarTaskViewModel.currentDate)
                }
            }
            
    }
    func TaskCardView(task: TaskModel) -> some View{
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top){
            
            if editButton?.wrappedValue == .active{
                
                VStack(spacing: 8){
                    
                    Button{
                        isSheetOpen.toggle()
                    }label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    .sheet(isPresented: $isSheetOpen){
                        EditTaskView(id: task.id ?? "")
                            .environmentObject(taskViewModel)
                    }
                    
                    Button{
                        withAnimation(.easeInOut){
                            taskViewModel.taskByDate.removeAll{$0.id == task.id}
                            Task{
                                try? await taskViewModel.deleteTask(taskId: task.id ?? "")
                            }
                        }
                    }label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.leading)
                
            }else{
                    VStack(spacing: 10){
                        Circle()
                            .fill(Color(hex: "050C9C"))
                            .frame(width: 15, height: 15)
                            .background(
                                Circle()
                                    .stroke(Color(hex: "050C9C"), lineWidth: 2)
                                    .padding(-3)
                            )
                        Rectangle()
                            .fill(Color(hex: "050C9C"))
                            .frame(width: 3)
                    }
                    .padding(.leading)
                    
            }
            CalendarTaskBlock( isChecked: $isChecked, id: task.id ?? "", title: task.title, subTitle: task.subTitle, date: task.deadline, timeToComplete: task.timeToComplete)
                .padding(.horizontal)
                .environmentObject(taskViewModel)
        }

    }
    
  
    
}

#Preview {
    CalendarView()
}


extension View{
    func hleading() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func htrailing() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hcenter() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
}


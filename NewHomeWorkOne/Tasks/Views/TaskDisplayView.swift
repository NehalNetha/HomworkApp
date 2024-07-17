import SwiftUI



struct TaskDisplayView: View {
    @Binding var tasks: [TaskModel]
    @EnvironmentObject var taskViewModel : TaskViewModel
    @State private var filter: TaskModel.TaskStatus?
    @State private var isChecked: Bool = false

    
    var openCount: Int
    var doneCount: Int
    var archivedCount: Int
    var allCount: Int
    
    
    var body: some View {
        VStack{
            
            FilterView(filter: $filter, openCount: openCount, doneCount: doneCount, archivedCount: archivedCount, allCount: allCount)
                .environmentObject(taskViewModel)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing: 18){
                    ForEach(filteredTasks){task in
                        
                        SwipeAction(cornerRadius: 20, direction: .trailing){
                            TaskBlock(isChecked: $isChecked, id: task.id ?? "", title: task.title, subTitle: task.subTitle, date: task.deadline, timeToComplete: task.timeToComplete)
                                .environmentObject(taskViewModel)
                        } actions: {
                            Action(tint: .orange, icon: "archivebox.fill") {
                                withAnimation(.easeInOut){
                                    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                        tasks[index].status = .archived
                                        taskViewModel.updateTasksCount()
                                        taskViewModel.updateTasksCountByAss()
                                    }
                                    Task{
                                        try await taskViewModel.updateTaskToArchive(taskID: task.id ?? "")
                                    }
                                }
                            }
                            
                            
                            Action(tint: .red, icon: "trash.fill"){
                                
                                print("wtf")
                                
                                withAnimation(.easeInOut){
                                    
                                    DispatchQueue.main.async {
                                        tasks.removeAll { $0.id == task.id }
                                        taskViewModel.updateTasksCount()
                                        taskViewModel.updateTasksCountByAss()
                                    }
                                    Task {
                                        do {
                                            print("Tried")
                                            try await taskViewModel.deleteTask(taskId: task.id ?? "")
                                            

                                        } catch {
                                            print("Error deleting task: \(error)")
                                        }
                                    }
                                }
                            }
                            
                           
                            
                            
                        }
                        .frame(width: 350)
                        
                    }
                }
            }
            .padding()
            
        }
    }
    
    var filteredTasks: [TaskModel] {
        if let filter = filter {
            return tasks.filter { $0.status == filter }
        } else {
            return tasks
        }
    }
    
}


struct SwipeAction<Content: View>: View{
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    let viewId = UUID()
    var body: some View{
        ScrollViewReader{scrollProxy in
            ScrollView(.horizontal){
                LazyHStack(spacing: 0){
                    content
                        .containerRelativeFrame(.horizontal)
                        .background{
                            if let firstAction = actions.first{
                                Rectangle()
                                    .fill(firstAction.tint)
                            }
                        }
                        .id(viewId)
                    ActionButtons{
                        withAnimation(.snappy){
                            scrollProxy.scrollTo(viewId, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                }
                .scrollTargetLayout()
                .visualEffect{content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background{
                if let lastAction = actions.last{
                    Rectangle()
                        .fill(lastAction.tint)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
        }
    }
    
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View{
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count) * 100)
            .overlay(alignment: direction.alignment){
                HStack(spacing: 0){
                    ForEach(actions) { button in
                        Button(action: {
                            Task{
                                resetPosition()
                            }
                            button.action()
                        }) {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .background(button.tint)
                    }
                                
                }
            }
    }
    
    
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat{
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return direction == .trailing ? (minX  > 0  ? -minX : 0) : (minX  < 0  ? -minX : 0)
    }
    
    
}



enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment{
        switch self{
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

struct Action: Identifiable{
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action : () -> ()
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}

struct FilterView: View{
    @EnvironmentObject var taskViewModel : TaskViewModel
    @Binding var filter: TaskModel.TaskStatus?
    var openCount: Int
    var doneCount: Int
    var archivedCount: Int
    var allCount: Int
    
    
    var body: some View{
        HStack{
            filterButton(title: "All", filter: nil, count: allCount)
                
                

            
            Divider()
                .frame(width: 2, height: 19)
                .background(Color.gray)
                .padding(.leading)
            
            Spacer()

            filterButton(title: "Open", filter: .open, count: openCount)
            Spacer()

            filterButton(title: "Done", filter: .Done, count: doneCount)
            Spacer()

            filterButton(title: "Archived", filter: .archived, count:  archivedCount)
           
        }
        .padding(.horizontal)
    }
    
    private func filterButton(title: String, filter: TaskModel.TaskStatus?, count: Int) -> some View{
        Button{
            self.filter = filter
            
        }label:{
            HStack{
                Text(title)
                    .foregroundColor(self.filter == filter ? .blue : .gray)
                
                Text("\(count)")
                    .font(.system(size: 15))
                    .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(self.filter == filter ? .blue : .gray)
                    )
                    .foregroundStyle(.white)
            }
        }
    }
}



#Preview {
    TaskDisplayView(tasks: .constant([TaskModel(assignmentId: "", userId: "", title: "", subTitle: "", deadline: Date(), timeToComplete: Date())]) , openCount: 3, doneCount: 5, archivedCount: 10, allCount: 18)
}

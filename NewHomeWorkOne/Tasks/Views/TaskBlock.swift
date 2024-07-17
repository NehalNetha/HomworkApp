import SwiftUI

struct TaskBlock: View {
    @Binding var isChecked: Bool 

    var id: String
    var title: String
    var subTitle: String
    var date: Date
    var timeToComplete: Date
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading){
                        Text(title)
                        Text(subTitle)
                            .foregroundStyle(.gray)
                    }
                    
                Spacer()
                
                    
                
                    Button{
                        
                        withAnimation(.easeInOut){
                            isChecked.toggle()
                            
                            taskViewModel.toggleStatusTask(taskID: id, isChecked: isChecked)


                        }
                        
                    } label: {
                        Image(systemName: isChecked ? "checkmark.circle" : "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(isChecked ? .blue : .gray)
                    }
                
                    
                    
                   
                
            }
            
            Divider()
                .frame(width: 310, height: 1)
                .background(Color(hex: "f8f8f8"))
            
            HStack {
                Text(DateUtils.formattedDate(date))
                Text("\(DateFormatter.localizedString(from: timeToComplete, dateStyle: .none, timeStyle: .short)) - \(DateFormatter.localizedString(from: timeToComplete.addingTimeInterval(3600), dateStyle: .none, timeStyle: .short))")
                    .foregroundStyle(.gray)
            }
        }
        .frame(width: 320, height: 100)
        .foregroundStyle(.black)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
        )
    }
    
}
#Preview {
    TaskBlock(
        isChecked: .constant(false), id: "234234",
        title: "I don't know let's see",
        subTitle: "Let's see",
        date: Date(),
        timeToComplete: Date()
    ).environmentObject(TaskViewModel())
}



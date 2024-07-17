import SwiftUI

struct DefaultAssignmentBlock: View {
    @State private var showHalfSheet = false
    @EnvironmentObject var assignViewModel: AssignmentViewModel
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showHalfSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .frame(width: 70, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.3))
                            )
                    }
                    .sheet(isPresented: $showHalfSheet) {
                        AddingAssignments()
                            .environmentObject(assignViewModel)
                    }

                    Spacer()
                }
            }
            .padding()
            .frame(width: 300, height: 170)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(hex: "3E6EE8"))
                    .shadow(color: .gray, radius: 5, x: 3, y: 3)
            )
            Spacer()
        }
    }
}

#Preview {
    DefaultAssignmentBlock()
        .environmentObject(AssignmentViewModel())
}

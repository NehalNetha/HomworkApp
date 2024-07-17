import SwiftUI

struct InsideProfile: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var fullName = ""
    @State private var email = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isEditingFullName = false


    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                VStack {
                    TopProfilePic()
                    ChangingProfile()
                        .padding(.bottom, 20)
                    DeleteAccount()
                    
                    Spacer()
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Settings")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditingFullName{
                        Button("Done") {
                            Task{
                                try await authViewModel.UpdateUser(fullname: fullName)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.green)
                    }
                }
            }
        }
        .onAppear {
            email = authViewModel.currentUser?.email ?? ""
            fullName = authViewModel.currentUser?.fullname ?? ""
        }
    }
}

extension InsideProfile {
    
    func TopProfilePic() -> some View {
        HStack {
            Spacer()
            Image(systemName: "person.circle")
                .padding(.top)
                .foregroundStyle(.gray).opacity(0.5)
                .font(.system(size: 70))
            Spacer()
        }
        .padding()
    }
    
    func ChangingProfile() -> some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text("FULL NAME")
                    .padding(.leading)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                TextField("Fullname", text: $fullName, onEditingChanged: {editing in
                        isEditingFullName = editing
                })
                    .padding(.leading)
                    .frame(width: 350, height: 45)
                    
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    )
            }
            .padding()
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("EMAIL")
                    .padding(.leading)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text(email)
                    .padding(.leading)
                    .frame(width: 350, height: 45)
                    
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    )
                    
            }
            .padding()
           
        }
        .padding()
    }
    
    func DeleteAccount() -> some View{
        VStack{
            Button{
                
            }label: {
                Text("Delete Account")
                    .foregroundStyle(.red)
            }
            .frame(width: 350, height: 45)
            
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
        }
    }
        
}

struct InsideProfile_Previews: PreviewProvider {
    static var previews: some View {
        InsideProfile()
    }
}

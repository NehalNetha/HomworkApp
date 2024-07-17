//
//  ProfileView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 21/06/24.
//

import SwiftUI


struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showAccount = false
    @State private var showGeneral = false

    var body: some View {
        VStack{
            
            UpperProfile()
                .padding(.top, 20)
            
            UpperList()
            
            
            Spacer()
            
            
//            Button{
//                authViewModel.signOut()
//            }label: {
//                Text("Logout")
//            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}


extension ProfileView{
    func UpperProfile() -> some View{
        HStack{
            Image(systemName: "person.circle")
                .font(.system(size: 45))
                .fontWeight(.light)
            
            VStack(alignment: .leading ,spacing: 5){
                Text(authViewModel.currentUser?.fullname ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("joined 3 July")
                    .font(.system(size: 15))
            }
            
            Spacer()
        }
        .padding()
    }
    
    
    func UpperList() -> some View{
        NavigationView{
            List{
                Section{
                    ListFunctionality(imageText: "person.circle", typeText: "Account"){
                        showAccount.toggle()
                    }
                    .sheet(isPresented: $showAccount){
                        InsideProfile()
                            .environmentObject(authViewModel)
                    }
                    
                    ListFunctionality(imageText: "gearshape", typeText: "General"){
                        showGeneral.toggle()
                    }
                    .sheet(isPresented: $showGeneral){
                        Text("General")
                    }
                    
                }
                
                
                Section{
                    Button{
                        authViewModel.signOut()
                    }label: {
                        HStack{
                            Spacer()
                            Text("Logout")
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}

struct ListFunctionality: View {
    var imageText: String
    var typeText: String
    var action: () -> Void
    
    var b : Bool?
    
    var body: some View {
        Button(action: action){
            HStack{
                HStack{
                        Image(systemName: imageText)
                            .foregroundStyle(Color(hex: "50B498"))
                            .font(.system(size: 27))
                            .fontWeight(.light)
                        
                    
                        Text(typeText)
                            .foregroundStyle(.black)
                         
                }
                
                Spacer()
                
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray).opacity(0.7)
                        .font(.system(size: 15))
            }
        }
       
    }
}

//
//  LoginView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 11/06/24.
//

import SwiftUI

struct LoginView: View {
    @State private var loginEmail = ""
    @State private var passswordLogin = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack{
                Image("LoginViewImage")
                    .resizable()
                    .frame(height: 420)
                    .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
                
                
                VStack(alignment: .leading){
                    Text("Login")
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))

                    
                    VStack(spacing: 18){
                        InputView(text: $loginEmail, placeholder: "example@gmail.com")
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                        
                        InputView(text: $passswordLogin, placeholder: "Password", secureField: true)
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 10))
                        
                        Button{
                            Task{
                                try await authViewModel.Signin(withEmail: loginEmail, password: passswordLogin)
                            }
                        }label: {
                            Text("Sign in")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        }
                        .background(Color(hex: "5AB2FF"))
                        
                        .cornerRadius(10)
                        
                    }
                    
                    
                }
                
              
                OrSeparator()
                
                HStack{
                    
                    Button{
                        Task{
                           try await authViewModel.signInGoogle()
                        }
                    }label: {
                        Image("googleImage")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .font(.title2)
                            .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(Color(hex: "E0E0E0"), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 10)
                    
                    
                    
                    Button{
                        
                    }label: {
                        Image(systemName: "apple.logo")
                            .font(.title2)
                            .padding()
                            .foregroundStyle(.black)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(Color(hex: "E0E0E0"), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 10)
                }
                
                Spacer()
                
                HStack{
                    Text("Don't have an account?")
                    
                    NavigationLink(destination: SignupView()){
                        
                        Text("Register")
                            .foregroundStyle(Color(hex: "FC4100"))
                    }
                    
                }
                .padding()
                .padding(.bottom, 50)

                
            }
            .ignoresSafeArea()
        }
    }
}


struct OrSeparator: View {
    var body: some View {
        HStack {
            Spacer()
            Divider()
                .frame(width: 152, height: 1)
                .background(Color.gray)
            Text("OR")
                .font(.callout)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
            Divider()
                .frame(width: 152, height: 1)
                .background(Color.gray)
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}

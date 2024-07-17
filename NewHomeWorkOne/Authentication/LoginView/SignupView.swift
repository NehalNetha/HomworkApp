//
//  SignupView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 13/06/24.
//

import SwiftUI

struct SignupView: View {
    
    @State private var emailSignup = ""
    @State private var passwordSignup = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    
    var body: some View {
        NavigationStack {
            VStack{
                Image("RectangleSignup")
                    .resizable()
                    .frame(height: 218)
                
                VStack(alignment: .leading){
                    Text("Sign Up")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .padding()
                    
                    VStack{
                        InputView(text: $emailSignup, placeholder: "Enter you Email")
                            .padding()
                        InputView(text: $passwordSignup, placeholder: "Password", secureField: true)
                            .padding()
                        
                        ZStack(alignment: .trailing){
                            InputView(text: $confirmPassword,  placeholder: "Confirm your Password", secureField: true)
                                .padding()
                            
                            if !passwordSignup.isEmpty && !confirmPassword.isEmpty{
                                if passwordSignup == confirmPassword{
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemGreen))
                                        .padding()

                                }else{
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.systemRed))
                                        .padding()

                                }
                            }
                            
                        }
                        
                        Button{
                            Task{
                                try await authViewModel.createUser(withEmail: emailSignup, password: passwordSignup)
                            }
                            
                        }label: {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        }
                        .background(Color(hex: "5AB2FF"))
                        
                        .cornerRadius(10)
                    }
                    
                    OrSeparator()
                    
                    HStack{
                        
                        Spacer()
                        
                        Button{
                            Task{
                                do{
                                    try await authViewModel.signInGoogle()
                                }catch{
                                    print("error loggin in with google \(error.localizedDescription)")
                                }
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
                        
                        Spacer()
                    }
                    .padding()
                    
                    
                    HStack{
                        Spacer()
                        Text("Don't have an account?")
                        Button{
                            dismiss()
                        }label: {
                            
                            Text("Login")
                                .foregroundStyle(Color(hex: "FC4100"))
                        }
                        
                        Spacer()
                        
                        
                    }
                    .padding()
                    .padding(.bottom, 50)


                    
                    
                    
                }
                
            }
            .ignoresSafeArea()
        }
    }
}

extension SignupView:  AuthenticationFormProtcol{
    var formIsValid: Bool {
        return !emailSignup.isEmpty && emailSignup.contains("@") && !passwordSignup.isEmpty && confirmPassword.count > 5 && confirmPassword == passwordSignup
    }
    
    
}

#Preview {
    SignupView()
}

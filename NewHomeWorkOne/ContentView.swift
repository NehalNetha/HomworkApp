//
//  ContentView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 11/06/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    var body: some View {
        Group{
            if authViewModel.userSession != nil{
                MainTabView()
                    .environmentObject(authViewModel)
            }else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())

}

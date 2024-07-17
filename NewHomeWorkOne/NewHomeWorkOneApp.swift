//
//  NewHomeWorkOneApp.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 11/06/24.
//

import SwiftUI
import Firebase

@main
struct NewHomeWorkOneApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)

        }
    }
}

//
//  SwiftUIView.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 09/07/24.
//

import SwiftUI

struct NotificationView: View {
    @State private var notificationFilter = NotificationFilter.all
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Notifications")
                    .font(.title2)
                    .fontWeight(.medium)
                Spacer()
            }
            
            Picker("", selection: $notificationFilter){
                ForEach(NotificationFilter.allCases){item in
                    Text(item.rawValue.capitalized)
                        .tag(item)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Text("Current filter: \(notificationFilter.rawValue)")
                .padding()
            
            Spacer()

        }
        
    }
    
    
    
    private enum NotificationFilter: String, Identifiable, CaseIterable{
        case all, unread
        
        var id: String{
            return rawValue
        }
    }
}

#Preview {
    NotificationView()
}

extension NotificationView{
    
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent{
        ToolbarItem{
            
        }
    }
    
}

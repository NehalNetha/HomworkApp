//
//  DefaultCourseBlock.swift
//  NewHomeWorkOne
//
//  Created by NehalNetha on 11/07/24.
//

import SwiftUI

struct DefaultCourseBlock: View {
    @State private var showHalfSheet = false
    @EnvironmentObject var courseViewModel: CourseViewModel
    var body: some View {
        NavigationView{
            HStack{
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button{
                            showHalfSheet.toggle()
                        }label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                                .frame(width: 50, height: 40)
                            
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white).opacity(0.3)
                                )
                        }
                        .sheet(isPresented: $showHalfSheet){
                            HalfSheetView()
                                .environmentObject(courseViewModel)
                        }
                        Spacer()
                    }
                    Spacer()
                    
                }
                .padding()
                .frame(width: 250, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(hex: "3E6EE8"))
                        .shadow(color: .gray, radius: 5, x: 3, y: 3)
                    
                )
                Spacer()

            }
        }
    }
}

#Preview {
    DefaultCourseBlock()
}

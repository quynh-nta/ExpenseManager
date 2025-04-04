//
//  HomeView.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 2025-04-04.
//

import SwiftUI

struct HomeView: View {
    @Binding var presentSideMenu: Bool//parent <=> child

    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .resizable()
                        .frame(width: 30, height: 20)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            
            Spacer()
            Text("Home View")
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(presentSideMenu: .constant(true))
    }
}

//
//  SideMenuView.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 2025-04-04.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var presentSideMenu: Bool//parent <=> child
    @Binding var selectedSideMenuTab: Int
    
    var body: some View {
        HStack{
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
            }
            Spacer()
        }.background(.clear)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(presentSideMenu: .constant(true), selectedSideMenuTab: .constant(0))
    }
}




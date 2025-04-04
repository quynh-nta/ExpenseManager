//
//  SideMenu.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 2025-04-04.
//

import SwiftUI

struct SideMenu: View {
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black.opacity(0.3).ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                
                //important
                content.transition(edgeTransition)
                        .background(
                            Color.clear
                        )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu(
            isShowing: .constant(true),
            content: AnyView(SideMenuView(presentSideMenu: .constant(true), selectedSideMenuTab: .constant(0)))
        )
    }
}

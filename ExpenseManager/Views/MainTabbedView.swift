//
//  MainTabbedView.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 2025-04-04.
//

import SwiftUI

struct MainTabbedView: View {
    @State var presentSideMenu = true //trạng thái nội bộ của view MainTabbedView
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        ZStack{
            TabView(selection: $selectedSideMenuTab) {
                HomeView(presentSideMenu: $presentSideMenu)
                    .tag(0)
            }
            
            SideMenu(isShowing: $presentSideMenu,
                     content: AnyView(SideMenuView(presentSideMenu: $presentSideMenu, selectedSideMenuTab: $selectedSideMenuTab)))
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView()
    }
}


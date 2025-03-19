//
//  ExpenseManagerApp.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 27/02/2025.
//

import SwiftUI

@main
struct ExpenseManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            MonthListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
        }
    }
}

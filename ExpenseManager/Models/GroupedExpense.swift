//
//  GroupedExpense.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 27/02/2025.
//

import Foundation

struct GroupedExpense {
    let date: Date
    let items: [(id:UUID, amount: Double, descriptions: String)]
}

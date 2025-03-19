//
//  CommonFunc.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 27/02/2025.
//

import Foundation

func yearMonthString(from date:Date) ->String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/yyyy"
    return formatter.string(from: date)
}

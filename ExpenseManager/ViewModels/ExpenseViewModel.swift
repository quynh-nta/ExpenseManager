//
//  ExpenseViewModel.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 27/02/2025.
//

import Foundation
import CoreData

class ExpenseViewModel: ObservableObject {
    @Published var groupedDictionary: [Date: [Expense]] = [:] {
        didSet {
            calculateSumOfMonth()
        }
    }
    @Published var expenses: [Expense] = []
    @Published var sumOfMonths: [String: Double] = [:] {
        didSet {
            var newSumOfYears: [String: Double] = [:]
            for (monthKey, amount) in sumOfMonths {
                // Giả sử định dạng key là "MM/YYYY"
                let components: [String.SubSequence] = monthKey.split(separator: "/")
                if components.count == 2, let year = components.last {
                    newSumOfYears[String(year), default: 0.0] += amount
                    print("Year: \(year), Amount: \(amount)")
                }
            }
            sumOfYears = newSumOfYears
        }
    }
    
    @Published var sumOfYears: [String: Double] = [:]
    
    
    @Published var isLoading: Bool = true  // Tracks loading state
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        fetchExpenses()
    }
    
    func fetchExpenses(){
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]
        
        do {
            expenses = try viewContext.fetch(request)
        } catch  {
            print("fetch expenses error : \(error)")
        }
    }
    
    func saveExpense(id: UUID?, amount: Double,date: Date,descriptions: String, items: [Item]){
        var saveExpense = nil as Expense?
        if let id = id {
            //update
            if let expense = expenses.count > 0 ? expenses.first(where: { $0.id == id }) : nil {
                saveExpense = expense
                saveExpense?.amount = Double(amount)
                saveExpense?.date = date
                saveExpense?.descriptions = descriptions
            }
        }
        else {
            saveExpense = Expense(context: viewContext)
            saveExpense?.id = UUID()
            saveExpense?.amount = Double(amount)
            saveExpense?.date = date
            saveExpense?.descriptions = descriptions
            
            //if month not exist in items => add new
            let monthExist = items.contains { item in
                return yearMonthString(from: date) == yearMonthString(from: item.timestamp!)
            }
            
            if(!monthExist){
                let newItem = Item(context: viewContext)
                newItem.timestamp = date
            }
        }
        
        saveContext(expense: saveExpense!)
        fetchExpenses()
    }
    
    func deleteExpense(expense: Expense){
        viewContext.delete(expense)
        saveContext(expense: expense)
    }
    
    private func saveContext(expense: Expense){
        do {
            try viewContext.save()
            updateGroupedDictionary(for: yearMonthString(from: expense.date ?? Date()))
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func updateGroupedDictionary(for month: String?) {
        DispatchQueue.main.async {
            let filteredExpenses: [Expense]
            
            if let selectedMonth = month {
                // Filter expenses by the selected month
                filteredExpenses = self.expenses.filter { expense in
                    guard let expenseDate = expense.date else { return false }
                    return yearMonthString(from: expenseDate) == selectedMonth
                }
            } else {
                // Use all expenses if no specific month is selected
                filteredExpenses = self.expenses
            }
            
            // Group expenses by day
            self.groupedDictionary = Dictionary(grouping: filteredExpenses, by: { Calendar.current.startOfDay(for: $0.date ?? Date()) })
            
            // Calculate sum for each month
            if (month != nil) {
                self.sumOfMonths[month!] = self.totalAmount(month: month!)
            }else{
                self.sumOfMonths = self.groupedDictionary.reduce(into: [:]) { result, entry in
                    let strKey = yearMonthString(from: entry.key)
                    result[strKey] = self.totalAmount(month: strKey)
                }
            }
            
            self.isLoading = false  // ✅ Data is ready
        }
    }
    
    
    func totalAmount(month: String) -> Double {
        let filterByMonth = self.expenses.filter { expense in
            guard let date = expense.date else{return false}
            return yearMonthString(from: date) == month
        }
        
        // .reduce(0): Bắt đầu từ giá trị khởi tạo 0.
        // Duyệt qua từng Expense trong filteredExpenses:
        // $0: Tổng tiền hiện tại (ban đầu là 0).
        // $1.amount: Số tiền của Expense hiện tại.
        return filterByMonth.reduce(0){$0 + $1.amount}
    }
    
    private func calculateSumOfMonth() {
        for (date, expenses) in groupedDictionary {
            let key = yearMonthString(from: date)
            let value = expenses.reduce(0) { $0 + $1.amount }
            sumOfMonths[key] = value
        }
    }
}

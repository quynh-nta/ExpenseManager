//
//  AddExpenseView.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 27/02/2025.
//

import SwiftUI

struct AddExpenseView: View {
    @Binding var expenseFocused: Expense?
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var descriptions: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Thông tin chi tiết"))
                {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Description", text: $descriptions)
                    TextField("Amount", text: $amount).keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Thêm chi tiêu")
            .toolbar{
                ToolbarItem{
                    Button("Cancel"){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem{
                    Button("Save"){
                        viewModel.saveExpense(id: expenseFocused?.id,
                                             amount: Double("\(amount)") ?? 0,
                                             date: date,
                                             descriptions: descriptions,
                                             items: Array(items))
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear(){
            if let expense = expenseFocused{
                descriptions = expense.descriptions ?? ""
                amount = String(format: "%.0f", expense.amount)
                date = expense.date ?? Date()
            }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(expenseFocused: .constant(nil as Expense?))
    }
}

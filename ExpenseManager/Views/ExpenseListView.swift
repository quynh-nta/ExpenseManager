//
//  ExpenseListView.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 27/02/2025.
//

import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var viewModel = ExpenseViewModel()
    var month: String //"MM/yyyy"
    
    @State private var showingAddExpense = false
    @State private var showingChart = false
    @State private var showDeleteConfirmation = false
    @State private var expenseFocused: Expense? = nil
    
    var body: some View {
        ZStack{
            NavigationView {
                List {
                    ForEach(Array(viewModel.groupedDictionary.keys).sorted(by: >), id: \.self) { date in
                        Section(header: Text("\(date, formatter: itemFormatter)").font(.caption)) {
                            ForEach(viewModel.groupedDictionary[date] ?? [], id: \.id) { expense in
                                VStack(alignment: .leading) {
                                    Text("🚀\(expense.descriptions ?? "No description")")
                                    Text("\(expense.amount, specifier: "%.0f VNĐ")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .onTapGesture {
                                    expenseFocused = expense
                                    showingAddExpense = true
                                }
                                .padding(.vertical, 5)
                            }
                            .onDelete { indexSet in
                                guard let expenses = viewModel.groupedDictionary[date],
                                      let firstIndex = indexSet.first,
                                      expenses.indices.contains(firstIndex) else { return }
                                
                                expenseFocused = expenses[firstIndex]
                                showDeleteConfirmation = true
                            }
                            
                            Text("Tổng: \((viewModel.groupedDictionary[date] ?? []).reduce(0) { $0 + $1.amount }, specifier: "%.0f VNĐ")")
                                .foregroundColor(.green)
                                .padding(.top)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Chi tiêu tháng \(month)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                            )
                    }
                    ToolbarItem{
                        Button(action: {
                            if expenseFocused != nil {
                                expenseFocused = nil
                            }
                            showingAddExpense.toggle()
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold)) // Adjust size & weight
                                .foregroundColor(.white) // Icon color
                                .frame(width: 30, height: 30) // Fixed size for button
                                .background(Color.green) // Background color
                                .clipShape(Circle()) // Ensures a perfect circle
                        }
                    }
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Xóa chi tiêu?"),
                        message: Text("Bạn có chắc chắn muốn xóa mục này không?"),
                        primaryButton: .destructive(Text("Xóa")) {
                            if let expense = expenseFocused {
                                viewModel.deleteExpense(expense: expense)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .onAppear {
                viewModel.updateGroupedDictionary(for: month)
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenseFocused: $expenseFocused,date: dateFromString(month) ?? Date())
                    .environmentObject(viewModel)
            }
            .onDisappear {
                viewModel.updateGroupedDictionary(for: nil)
            }
            
            VStack {
                Spacer()
                Text("Tổng/tháng: \(viewModel.totalAmount(month: month), specifier: "%.0f VNĐ")")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                    )
                
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()


struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseListView(month: "03/2025")
    }
}

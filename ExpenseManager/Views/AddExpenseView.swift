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
    @State var date: Date = Date()
    
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0 // Không hiển thị số thập phân
        return formatter
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section()
                {
                    DatePicker("Ngày:", selection: $date, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "vi_VN"))
                    CategoriesView()
                    TextField("Mô tả", text: $descriptions)
                    TextField("Giá tiền",  text: Binding(
                        get: { self.amount },
                        set: { newValue in
                            // Lọc chỉ giữ lại các ký tự số
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if let number = Double(filtered) {
                                // Sử dụng NumberFormatter để định dạng số theo locale vi_VN
                                let formatter = NumberFormatter()
                                formatter.locale = Locale(identifier: "vi_VN")
                                formatter.numberStyle = .decimal
                                formatter.maximumFractionDigits = 0
                                if let formatted = formatter.string(from: NSNumber(value: number)) {
                                    self.amount = formatted
                                } else {
                                    self.amount = newValue
                                }
                            } else {
                                self.amount = newValue
                            }
                        }))
                        .keyboardType(.decimalPad)
                }
                
                VStack(spacing: 8) {
                    Text("Chọn nhanh")
                        .font(.headline)
                        .bold()
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            amount += "000"
                        }) {
                            Text(".000")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                )
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle()) // Giới hạn vùng nhận sự kiện
                        
                        Button(action: {
                            amount += "000000"
                        }) {
                            Text(".000.000")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                )
                                .cornerRadius(12)
                        }
                        .contentShape(Rectangle()) // Giới hạn vùng nhận sự kiện
                    }
                    .padding(.horizontal) // Áp dụng padding bên ngoài HStack để tránh trùng lặp
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
            }
            .navigationTitle("Thêm chi tiêu")
            .toolbar{
                ToolbarItem{
                    Button("Thoát"){
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem{
                    Button("Lưu"){
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

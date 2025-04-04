//
//  MonthListView.swift
//  ExpenseManager
//
//  Created by Nguyen Thi Anh Quynh on 27/02/2025.
//

import SwiftUI

struct MonthListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var showingAddExpense: Bool = false
    @StateObject var viewModel = ExpenseViewModel()
    
    // Sử dụng state riêng cho nhóm danh sách tháng và cho nhóm tùy chọn
    @State private var expandedYears: Set<String> = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return [String(currentYear)]
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(Array(viewModel.sumOfYears).sorted(by: { $0.key > $1.key }), id: \.key) { year, value in
                        DisclosureGroup(
                            isExpanded: Binding<Bool>(
                                get: { expandedYears.contains(year) },
                                set: { newValue in
                                    if newValue {
                                        expandedYears.insert(year)
                                    } else {
                                        expandedYears.remove(year)
                                    }
                                })
                        ){
                            monthListContent(for: year)
                        } label:{
                            Text("Năm: \(year) 👉 \(value, specifier: "%.0f") VNĐ")
                                .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal,16)
                                            .padding(.vertical, 4)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.purple, .blue]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(10)
                                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                            
                        }
                        .disclosureGroupStyle()  // Sử dụng style tùy chỉnh
                        .foregroundColor(.primary)
                    }
                    .animation(.easeInOut, value: expandedYears)
                }
            }
            .navigationTitle("THỐNG KÊ NĂM")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddExpense.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense, onDismiss: {
                viewModel.updateGroupedDictionary(for: nil)
            }) {
                AddExpenseView(expenseFocused: .constant(nil))
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.updateGroupedDictionary(for: nil)
        }
    }
    
    private func monthListContent(for year: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.isLoading {
                Text("Loading...")
                    .foregroundColor(.gray)
            } else {
                // Filter and sort the dictionary into an array
                let filteredItems = Array(viewModel.sumOfMonths)
                    .filter { $0.key.hasSuffix(year) }
                    .sorted { $0.key > $1.key }
                
                ForEach(Array(filteredItems.enumerated()), id: \.element.key) { index, item in
                    VStack(spacing: 0) {
                        NavigationLink {
                            ExpenseListView(viewModel: viewModel, month: item.key)
                        } label: {
                            HStack {
                                Text(item.key)
                                Spacer()
                                Text("\(item.value, specifier: "%.0f") VNĐ")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 8)
                        }
                        
                        // Add a divider if not the last item
                        if index < filteredItems.count - 1 {
                            Divider()
                        }
                    }
                }
                .onDelete { offsets in
                    withAnimation {
                        // Map the deleted indices to keys and remove them from the dictionary
                        offsets.map { filteredItems[$0].key }
                            .forEach { key in
                                viewModel.sumOfMonths.removeValue(forKey: key)
                            }
                    }
                }
            }
        }
        .padding(.leading)
    }
    
    /// Hàm xử lý xóa Item từ Core Data
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

/// Extension view dùng để áp dụng style chung cho DisclosureGroup
extension View {
    func disclosureGroupStyle() -> some View {
        self
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

struct MonthListView_Previews: PreviewProvider {
    static var previews: some View {
        MonthListView()
    }
}

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
    
    @State var showingAddExpense: Bool = false
    
    @StateObject var viewModel = ExpenseViewModel()
    
    var body: some View {
        NavigationView{
            List{
                if viewModel.isLoading {
                    Text("Loading...").foregroundColor(.gray)  // Show loading state
                } else {
                    ForEach(Array(viewModel.sumOfMonths).sorted(by: { $0.key > $1.key }), id: \.key) { key, value in
                        NavigationLink {
                            ExpenseListView(viewModel: viewModel, month: key ?? yearMonthString(from: Date())) //! giả định rằng nó không phải nil.
                        } label: {
                            Text(key)
                            Spacer()
                            Text("\(value, specifier: "%.0f")")
                                .font(.headline)
                                .foregroundColor(Color.green)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }.toolbar{
                ToolbarItem{
                    Button(action: {
                        showingAddExpense.toggle()
                    }){
                        Label("Thêm tháng", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenseFocused: .constant(nil as Expense?))
                    .environmentObject(viewModel)
            }
        }.onAppear(){
            viewModel.updateGroupedDictionary(for: (nil as String?))
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct MonthListView_Previews: PreviewProvider {
    static var previews: some View {
        MonthListView()    }
}
